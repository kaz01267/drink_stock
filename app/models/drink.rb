class Drink < ApplicationRecord
  belongs_to :user
  has_many :drink_records, dependent: :destroy

  before_validation :normalize_name

  validates :name, presence: true,
                   uniqueness: { scope: :user_id, case_sensitive: false }
  validates :stock_ml, numericality: { greater_than_or_equal_to: 0 }

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end
