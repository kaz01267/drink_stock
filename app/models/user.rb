class User < ApplicationRecord
  has_many :drinks, dependent: :destroy
  has_many :drink_records, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, length: { maximum: 20 }, allow_blank: true
end
