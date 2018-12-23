class Balance < ApplicationRecord
  has_many :assets, class_name: 'AssetBalance', dependent: :destroy
  belongs_to :user

  monetize :cash_cents,
    numericality: { greater_than_or_equal_to: 0 }

  def increase(value, options = {})
    errors.add(:base, I18n.t('balance.increase.wrong_number')) and return false if value < Money.new(0)

    self.cash += value
    options[:save] ? self.save : true
  end

  def decrease(value, options = {})
    errors.add(:base, I18n.t('balance.decrease.wrong_number')) and return false if value < Money.new(0)
    errors.add(:base, I18n.t('balance.decrease.not_enough')) and return false if value > self.cash

    self.cash -= value
    options[:save] ? self.save : true
  end

  def increase!(value)
    increase(value, save: true)
  end

  def decrease!(value)
    decrease(value, save: true)
  end

  def display_informations
    hash = { cash: self.cash.format(symbol: false).to_f }
    self.assets.joins(:asset).each do |asset_balance|
      hash[asset_balance.asset.name] = asset_balance.amount
    end
    hash
  end
end
