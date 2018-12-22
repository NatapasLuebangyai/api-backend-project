class Balance < ApplicationRecord
  has_many :assets, class_name: 'AssetBalance', dependent: :destroy
  belongs_to :user

  monetize :cash_cents,
    numericality: { greater_than_or_equal_to: 0 }
end
