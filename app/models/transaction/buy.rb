class Transaction::Buy < Transaction::Base
  validates :asset,
    presence: true

  def perform(options = {})
    balance = user.balance
    asset_balance = balance.assets.where(asset_id: asset.id).first
    asset_balance ||= AssetBalance.new(balance: balance, asset: asset)
    errors.add(:base, balance.errors.full_messages) and return false unless balance.decrease!(asset.price)
    asset_balance.increase!
  end

  protected

  def dynamic_informations
    { asset: self.asset.name }
  end
end
