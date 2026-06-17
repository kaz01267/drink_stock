class DrinkRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_drink, except: :index
  before_action :set_drink_record, only: %i[edit update destroy]

  def index
    @drink_records = current_user.drink_records.includes(:drink).order(consumed_at: :desc)

    @weekly_consumed_ml = current_user.drink_records
      .where(consumed_at: 7.days.ago.beginning_of_day..Time.current)
      .sum(:consumed_ml)

    @monthly_record_count = current_user.drink_records
      .where(consumed_at: 30.days.ago.beginning_of_day..Time.current)
      .count

    @monthly_consumed_ml = current_user.drink_records
      .where(consumed_at: 30.days.ago.beginning_of_day..Time.current)
      .sum(:consumed_ml)
  end

  def new
    @drink_record = @drink.drink_records.new(consumed_at: Time.current)
  end

  def create
    @drink_record = @drink.drink_records.new(drink_record_params.merge(user: current_user))

    @drink.with_lock do
      ActiveRecord::Base.transaction do
        consumed  = @drink_record.consumed_ml.to_i
        stock     = @drink.stock_ml.to_i
        new_stock = stock - consumed

        if new_stock < 0
          @drink_record.errors.add(:consumed_ml, "が在庫を超えています")
          raise ActiveRecord::RecordInvalid.new(@drink_record)
        end

        @drink_record.save!
        @drink.update!(stock_ml: new_stock)
      end
    end

    redirect_to drinks_path, notice: "飲酒記録を登録しました"
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def quick_create
    @drink = current_user.drinks.find(params[:drink_id])
    consumed_ml = params[:consumed_ml].to_i

    if consumed_ml <= 0
      redirect_to dashboard_path, alert: "飲んだ量を選択してください"
      return
    end

    @drink_record = @drink.drink_records.new(
      consumed_ml: consumed_ml,
      consumed_at: Time.current,
      user: current_user
    )

    @drink.with_lock do
      ActiveRecord::Base.transaction do
        new_stock = @drink.stock_ml.to_i - consumed_ml

        if new_stock < 0
          redirect_to dashboard_path, alert: "在庫を超える量は記録できません"
          return
        end

        @drink_record.save!
        @drink.update!(stock_ml: new_stock)
      end
    end

    redirect_to dashboard_path, notice: "飲酒記録を登録しました"
  rescue ActiveRecord::RecordInvalid
    redirect_to dashboard_path, alert: "飲酒記録を登録できませんでした"
  end


  def edit
  end

  def update
    new_consumed = drink_record_params[:consumed_ml].to_i

    ActiveRecord::Base.transaction do
      @drink.lock!

      old_consumed = @drink_record.consumed_ml_in_database || 0
      restored_stock = @drink.stock_ml + old_consumed
      new_stock = restored_stock - new_consumed

      if new_stock < 0
        @drink_record.assign_attributes(drink_record_params)
        @drink_record.errors.add(:consumed_ml, "が在庫を超えています")
        raise ActiveRecord::RecordInvalid, @drink_record
      end

      @drink_record.update!(drink_record_params)
      @drink.update!(stock_ml: new_stock)
    end

    redirect_to after_update_drink_record_path, notice: "飲酒記録を更新しました"
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    ActiveRecord::Base.transaction do
      @drink.lock!

      @drink.update!(stock_ml: @drink.stock_ml + @drink_record.consumed_ml)
      @drink_record.destroy!
    end

    redirect_to after_destroy_drink_record_path, notice: "飲酒記録を削除しました"
  end

  def normalize_consumed_at
    self.consumed_at = Time.zone.parse(consumed_at) if consumed_at.is_a?(String)
  end

  private

  def set_drink
    @drink = current_user.drinks.find(params[:drink_id])
  end

  def set_drink_record
    @drink_record = @drink.drink_records.find(params[:id])
  end

  def drink_record_params
    params.require(:drink_record).permit(:consumed_ml, :consumed_at)
  end

  def after_update_drink_record_path
    if params[:return_to] == "show"
      drink_path(@drink)
    else
      drink_records_path
    end
  end

  def after_destroy_drink_record_path
    if params[:return_to] == "show"
      drink_path(@drink)
    else
      drink_records_path
    end
  end
end
