class DrinkRecord < ApplicationRecord
  belongs_to :user
  belongs_to :drink

  validates :consumed_ml, numericality: { greater_than: 0 }
  validates :consumed_at, presence: true
  validate :stock_is_enough

  private

  def stock_is_enough
    return if drink.nil? || consumed_ml.nil? || drink.stock_ml.nil?

    old_consumed = persisted? ? (consumed_ml_in_database || 0) : 0
    max_allowed  = drink.stock_ml + old_consumed

    errors.add(:consumed_ml, "が在庫を超えています") if consumed_ml > max_allowed
  end
end
