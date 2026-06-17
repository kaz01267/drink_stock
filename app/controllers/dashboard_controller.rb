class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @suggested_drink = current_user.drinks.where("stock_ml > 0").order("RANDOM()").first
    @available_drinks = current_user.drinks.where("stock_ml > 0").order(created_at: :desc)
    @drink_count = current_user.drinks.count

    @weekly_consumed_ml = current_user.drink_records
      .where(consumed_at: 7.days.ago.beginning_of_day..Time.current)
      .sum(:consumed_ml)

    @monthly_record_count = current_user.drink_records
      .where(consumed_at: 30.days.ago.beginning_of_day..Time.current)
      .count

    @monthly_consumed_ml = current_user.drink_records
      .where(consumed_at: 30.days.ago.beginning_of_day..Time.current)
      .sum(:consumed_ml)

    @recent_drink_logs = current_user.drink_logs.includes(:drink).order(logged_at: :desc).limit(3)
  end
end