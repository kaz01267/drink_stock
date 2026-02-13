class Drink < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :stock_ml, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
