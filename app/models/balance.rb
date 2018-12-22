class Balance < ApplicationRecord
  belongs_to :user

  monetize :cash_cents,
    numericality: { greater_than_or_equal_to: 0 }
end
