class AssetBalance < ApplicationRecord
  belongs_to :asset
  belongs_to :balance

  validates :amount,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }
end
