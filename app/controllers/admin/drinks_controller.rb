class Admin::DrinksController < Admin::BaseController
  def index
    @drinks = Drink.left_joins(:user).includes(:user).order(created_at: :desc)

    if params[:q].present?
      @drinks = @drinks.where(
        "drinks.name ILIKE :q OR users.name ILIKE :q OR users.email ILIKE :q",
        q: "%#{params[:q]}%"
      )
    end
  end
end
