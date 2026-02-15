class DrinkRecord < ApplicationRecord
  belongs_to :user
  belongs_to :drink

  validates :consumed_ml, numericality: { greater_than: 0 }
  validates :consumed_at, presence: true
  validate :stock_is_enough

  private

  def stock_is_enough
    return if drink.nil? || consumed_ml.nil?
    errors.add(:consumed_ml, "が在庫を超えています") if consumed_ml > drink.stock_ml
  end
end
