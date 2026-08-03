class Admin::DrinkRecordsController < Admin::BaseController
  def index
    @drink_records = DrinkRecord
                       .left_joins(:user, :drink)
                       .includes(:user, :drink)
                       .order(consumed_at: :desc)

    if params[:q].present?
      @drink_records = @drink_records.where(
        "drinks.name ILIKE :q OR users.name ILIKE :q OR users.email ILIKE :q",
        q: "%#{params[:q]}%"
      )
    end
  end
end
