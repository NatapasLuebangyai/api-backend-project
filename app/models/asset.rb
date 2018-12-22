class Asset < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: {
      case_sensitive: false,
      conditions: -> { where.not(soft_deleted: true) }
    }

  monetize :price_cents,
    numericality: { greater_than_or_equal_to: 0 }

  def soft_delete!
    self.update(soft_deleted: true)
  end
end
