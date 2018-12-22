class Balance < ApplicationRecord
  has_many :assets, class_name: 'AssetBalance', dependent: :destroy
  belongs_to :user

  monetize :cash_cents,
    numericality: { greater_than_or_equal_to: 0 }

  def increase(value)
    errors.add(:base, I18n.t('balance.increase.wrong_number')) and return false if value < Money.new(0)
    self.cash += value
  end

  def decrease(value)
    errors.add(:base, I18n.t('balance.decrease.wrong_number')) and return false if value < Money.new(0)
    errors.add(:cash, I18n.t('balance.decrease.not_enough')) and return false if value > self.cash
    self.cash -= value
  end

  def increase!(value)
    increase(value) ? self.save : false
  end

  def decrease!(value)
    decrease(value) ? self.save : false
  end
end
