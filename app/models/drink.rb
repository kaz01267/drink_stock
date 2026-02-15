class Drink < ApplicationRecord
  belongs_to :user
  has_many :drink_records, dependent: :destroy

  validates :name, presence: true
  validates :stock_ml, numericality: { greater_than_or_equal_to: 0 }
end
