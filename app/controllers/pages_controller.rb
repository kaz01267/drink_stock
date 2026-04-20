class PagesController < ApplicationController
  def home
    redirect_to drinks_path if user_signed_in?
  end

  def account
    authenticate_user!
  end

  def terms; end

  def privacy; end

  def guide; end
end
