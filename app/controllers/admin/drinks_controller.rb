class Admin::DrinksController < Admin::BaseController
  def index
    @drinks = Drink.includes(:user).order(created_at: :desc)
  end
end
