class AssetBalance < ApplicationRecord
  include Cacheable

  belongs_to :asset
  belongs_to :balance

  validates :amount,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  after_save :write_in_cache

  def increase(value, options = {})
    errors.add(:base, I18n.t('asset_balance.increase.wrong_number')) and return false if value < 0
    self.amount += value
    options[:save] ? self.save : true
  end

  def decrease(value, options = {})
    errors.add(:base, I18n.t('asset_balance.decrease.wrong_number')) and return false if value < 0
    errors.add(:base, I18n.t('asset_balance.decrease.not_enough')) and return false if value > self.amount
    self.amount -= value
    options[:save] ? self.save : true
  end

  def increase!(value = 1)
    increase(value, save: true)
  end

  def decrease!(value = 1)
    decrease(value, save: true)
  end

  private

  def write_in_cache
    cache_write(self)
  end
end
