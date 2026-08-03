class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users_count = User.count
    @drinks_count = Drink.count
    @drink_records_count = DrinkRecord.count
    @drink_logs_count = DrinkLog.count
  end

  private

  def require_admin
    redirect_to root_path, alert: "管理者のみアクセスできます。" unless current_user.admin?
  end
end
