class User < ApplicationRecord
  has_many :drinks, dependent: :destroy
  has_many :drink_records, dependent: :destroy
  has_many :drink_logs, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  validates :name, length: { maximum: 20 }, allow_blank: true

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)

    user.email = auth.info.email
    user.name = auth.info.name if user.name.blank?
    user.password = Devise.friendly_token[0, 20] if user.encrypted_password.blank?

    user.save!
    user
  end
end
