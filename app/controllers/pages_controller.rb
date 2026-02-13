class PagesController < ApplicationController
  before_action  :authenticate_user!

  def account
  end
end
