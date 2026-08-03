class Admin::DrinkRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @drink_records = DrinkRecord.includes(:user, :drink).order(consumed_at: :desc)
  end

  private

  def require_admin
    redirect_to root_path, alert: "管理者のみアクセスできます。" unless current_user.admin?
  end
end
