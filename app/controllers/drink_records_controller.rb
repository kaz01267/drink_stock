class DrinkRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_drink
  before_action :set_drink_record, only: %i[edit update destroy]

  def new
    @drink_record = @drink.drink_records.new(consumed_at: Time.current)
  end

  def create
    @drink_record = @drink.drink_records.new(drink_record_params.merge(user: current_user))

    @drink.with_lock do
      ActiveRecord::Base.transaction do
        # ★ここに入れる（在庫0はOK、マイナスはNG）
        new_stock = @drink.stock_ml - @drink_record.consumed_ml
        if new_stock < 0
          @drink_record.errors.add(:consumed_ml, "が在庫を超えています")
          raise ActiveRecord::Rollback
        end

        @drink_record.save!              # 記録を保存
        @drink.update!(stock_ml: new_stock) # 在庫を更新（0もOK）
      end
    end

    if @drink_record.errors.any?
      render :new, status: :unprocessable_entity
    else
      redirect_to drinks_path, notice: "飲酒記録を登録し、在庫を更新しました"
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
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
        @drink_record.assign_attributes(drink_record_params) # 画面に入力値を残す
        @drink_record.errors.add(:consumed_ml, "が在庫を超えています")
        raise ActiveRecord::RecordInvalid, @drink_record
      end

      @drink_record.update!(drink_record_params)
      @drink.update!(stock_ml: new_stock)
    end

    redirect_to drink_path(@drink), notice: "飲酒記録を更新しました"
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    ActiveRecord::Base.transaction do
      @drink.lock!

      # 削除する分、在庫を戻す
      @drink.update!(stock_ml: @drink.stock_ml + @drink_record.consumed_ml)
      @drink_record.destroy!
    end

    redirect_to drink_path(@drink), notice: "飲酒記録を削除しました"
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
end
