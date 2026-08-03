class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(created_at: :desc)

    if params[:q].present?
      @users = @users.where(
        "name ILIKE :q OR email ILIKE :q",
        q: "%#{params[:q]}%"
      )
    end
  end
end
