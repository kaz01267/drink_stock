class Drink < ApplicationRecord
  belongs_to :user
  has_many :drink_records, dependent: :destroy
  has_many :drink_logs, dependent: :destroy

  before_validation :normalize_name

  validates :name, presence: true,
                   uniqueness: { scope: :user_id, case_sensitive: false }
  validates :stock_ml, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name stock_ml created_at updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[drink_records drink_logs user]
  end

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end
