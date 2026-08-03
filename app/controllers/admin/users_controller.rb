class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.order(created_at: :desc)
  end

  private

  def require_admin
    redirect_to root_path, alert: "管理者のみアクセスできます。" unless current_user.admin?
  end
end
