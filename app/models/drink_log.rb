class DrinkLog < ApplicationRecord
  belongs_to :user
  belongs_to :drink, optional: true

  before_validation :set_default_logged_at

  validates :memo, length: { maximum: 500 }, allow_blank: true
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :drink_name, presence: true, if: -> { drink.blank? }

  private

  def set_default_logged_at
    self.logged_at ||= Time.current
  end
end
