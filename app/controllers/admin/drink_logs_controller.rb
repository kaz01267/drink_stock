class Admin::DrinkLogsController < Admin::BaseController
  def index
    @drink_logs = DrinkLog
                    .left_joins(:user, :drink)
                    .includes(:user, :drink)
                    .order(logged_at: :desc)

    if params[:q].present?
      @drink_logs = @drink_logs.where(
        "drink_logs.drink_name ILIKE :q OR drinks.name ILIKE :q OR drink_logs.memo ILIKE :q OR users.name ILIKE :q OR users.email ILIKE :q",
        q: "%#{params[:q]}%"
      )
    end
  end
end
