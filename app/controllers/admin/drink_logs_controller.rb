class Admin::DrinkLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @drink_logs = DrinkLog.includes(:user, :drink).order(logged_at: :desc)
  end

  private

  def require_admin
    redirect_to root_path, alert: "管理者のみアクセスできます。" unless current_user.admin?
  end
end
