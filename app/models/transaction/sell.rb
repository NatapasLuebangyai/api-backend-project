class Transaction::Sell < Transaction::Base
  validates :asset,
    presence: true

  def perform(options = {})
    errors.add(:base, user_asset_balance.errors.full_messages) and return false unless user_asset_balance.decrease!
    user_balance.increase!(asset.price)
  end

  protected

  def dynamic_informations
    { asset: cache_query(Asset, id: self.asset_id).name }
  end
end
