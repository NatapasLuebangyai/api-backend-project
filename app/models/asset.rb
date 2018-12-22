class Asset < ApplicationRecord
  attr_accessor :force_destroy

  has_many :asset_balances, dependent: :destroy
  has_many :transactions, class_name: 'Transaction::Base'

  validates :name,
    presence: true,
    uniqueness: {
      case_sensitive: false,
      conditions: -> { where.not(soft_deleted: true) }
    }

  monetize :price_cents,
    numericality: { greater_than_or_equal_to: 0 }

  before_destroy :unable_to_destroy

  def soft_delete!
    self.asset_balances.destroy_all
    self.update(soft_deleted: true)
  end

  private

  def unable_to_destroy
    throw :abort unless force_destroy
  end
end
