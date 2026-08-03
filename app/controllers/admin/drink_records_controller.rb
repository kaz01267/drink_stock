class Admin::DrinkRecordsController < Admin::BaseController
  def index
    @drink_records = DrinkRecord.includes(:user, :drink).order(consumed_at: :desc)
  end
end
