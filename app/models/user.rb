class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Doorkeeper token authentication
  has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
    foreign_key: :resource_owner_id, dependent: :delete_all
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
    foreign_key: :resource_owner_id, dependent: :delete_all

  has_one :balance, validate: true, dependent: :destroy

  validates :balance, presence: true, on: :update

  after_create :create_balance

  private

  def create_balance
    return if self.balance.present?
    self.balance = Balance.new
  end
end
