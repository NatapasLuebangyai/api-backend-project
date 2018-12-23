class Transaction::Buy < Transaction::Base
  validates :asset,
    presence: true

  def perform(options = {})
    if user_balance.decrease!(asset.price)
      user_asset_balance.increase!
    else
      errors.add(:base, user_balance.errors.full_messages)
      false
    end
  end

  protected

  def dynamic_informations
    { asset: cache_query(Asset, id: self.asset_id).name }
  end
end
