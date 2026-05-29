class DrinkLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_drink, only: %i[new create edit update destroy]
  before_action :set_drink_log, only: %i[edit update destroy]

  def index
    @drink_logs = current_user.drink_logs.includes(:drink).order(logged_at: :desc)
  end

  def new
    @drink_log = current_user.drink_logs.new(logged_at: Time.current)
    @drink_log.drink = @drink if @drink.present?
  end

  def create
    @drink_log = current_user.drink_logs.new(drink_log_params)
    @drink_log.drink = @drink if @drink.present?

    if @drink_log.save
      redirect_to drink_logs_path, notice: "お酒ログを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @drink_log.update(drink_log_params)
      redirect_to drink_logs_path, notice: "お酒ログを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @drink_log.destroy!
    redirect_to drink_logs_path, notice: "お酒ログを削除しました"
  end

  private

  def set_drink
    @drink = current_user.drinks.find_by(id: params[:drink_id])
  end

  def set_drink_log
    @drink_log = current_user.drink_logs.find(params[:id])
    @drink = @drink_log.drink
  end

  def drink_log_params
    params.require(:drink_log).permit(:drink_name, :memo, :rating, :logged_at)
  end
end
