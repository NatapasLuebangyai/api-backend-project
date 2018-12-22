class Transaction::Buy < Transaction::Base
  validates :asset,
    presence: true

  def perform
    balance = user.balance
    asset_balance = balance.assets.where(asset_id: asset.id).first
    asset_balance ||= AssetBalance.new(balance: balance, asset: asset)
    if balance.decrease!(asset.price)
      asset_balance.increase!
    else
      errors.add(:base, balance.errors.full_messages)
      try(:throw, :abort)
      false
    end
  end
end
