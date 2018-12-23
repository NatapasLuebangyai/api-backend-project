class Transaction::TopUp < Transaction::Base
  before_create :try_perform
  
  def perform(options = { save: true })
    balance = user.balance
    return true if balance.increase(self.amount, options)
    errors.add(:base, balance.errors.full_messages)
    false
  end

  protected

  def skip_perform_on_create?
    true
  end

  def dynamic_informations
    {
      asset: 'cash',
      approved: self.approved || false
    }
  end
end
