class Admin::DrinkLogsController < Admin::BaseController
  def index
    @drink_logs = DrinkLog.includes(:user, :drink).order(logged_at: :desc)
  end
end
