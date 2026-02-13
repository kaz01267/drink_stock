class DrinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_drink, only: %i[edit update destroy]

  def index
    @drinks = current_user.drinks.order(created_at: :desc)
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

  private

  def set_drink
    @drink = current_user.drinks.find(params[:id])
  end

  def drink_params
    params.require(:drink).permit(:name, :stock_ml)
  end
end
