class AssetBalance < ApplicationRecord
  belongs_to :asset
  belongs_to :balance

  validates :amount,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  def increase(value = 1)
    errors.add(:base, I18n.t('asset_balance.increase.wrong_number')) and return false if value < 0
    self.amount += value
  end

  def decrease(value = 1)
    errors.add(:base, I18n.t('asset_balance.decrease.wrong_number')) and return false if value < 0
    errors.add(:cash, I18n.t('asset_balance.decrease.not_enough')) and return false if value > self.amount
    self.amount -= value
  end

  def increase!(value = 1)
    increase(value) ? self.save : false
  end

  def decrease!(value = 1)
    decrease(value) ? self.save : false
  end
end
