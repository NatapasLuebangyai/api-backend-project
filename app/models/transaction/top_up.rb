class Transaction::TopUp < Transaction::Base
  def perform(options = { save: true })
    return true if user_balance.increase(self.amount, options)
    errors.add(:base, user_balance.errors.full_messages)
    false
  end

  protected

  def perform_on_create
    try_perform
  end

  def dynamic_informations
    {
      asset: 'cash',
      approved: self.approved || false
    }
  end
end
