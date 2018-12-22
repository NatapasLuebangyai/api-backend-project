class Transaction::Sell < Transaction::Base
  validates :asset,
    presence: true

  def perform
    balance = user.balance
    asset_balance = balance.assets.where(asset_id: asset.id).first
    asset_balance ||= AssetBalance.new(balance: balance, asset: asset)
    if asset_balance.decrease!
      balance.increase!(asset.price)
    else
      errors.add(:base, asset_balance.errors.full_messages)
      try(:throw, :abort)
      false
    end
  end
end
