class DrinkRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_drink

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

  private

  def set_drink
    @drink = current_user.drinks.find(params[:drink_id])
  end

  def drink_record_params
    params.require(:drink_record).permit(:consumed_ml, :consumed_at)
  end
end
