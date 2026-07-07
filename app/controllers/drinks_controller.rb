class DrinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_drink, only: %i[edit update destroy]

  def index
    @q = Drink.where(user: current_user).ransack(params[:q])
    @drinks = @q.result.order(created_at: :desc)

    @suggested_drink = current_user.drinks.where("stock_ml > 0").order("RANDOM()").first
  end

  def new
    @drink = current_user.drinks.new
  end

  def create
    @drink = current_user.drinks.new(drink_params)
    if @drink.save
      redirect_to drinks_path, notice: "お酒を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @drink.update(drink_params)
      redirect_to drinks_path, notice: "お酒を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @drink.destroy
    redirect_to drinks_path, notice: "お酒を削除しました"
  end

  def show
    @drink = current_user.drinks.find(params[:id])
    @drink_records = @drink.drink_records.order(consumed_at: :desc)
  end

  private

  def set_drink
    @drink = current_user.drinks.find(params[:id])
  end

  def drink_params
    params.require(:drink).permit(:name, :stock_ml)
  end
end
