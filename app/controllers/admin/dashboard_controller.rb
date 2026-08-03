class Admin::DashboardController < Admin::BaseController
  def index
    @users_count = User.count
    @drinks_count = Drink.count
    @drink_records_count = DrinkRecord.count
    @drink_logs_count = DrinkLog.count
  end
end
