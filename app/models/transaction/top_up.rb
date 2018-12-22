class Transaction::TopUp < Transaction::Base
  monetize :amount_cents,
    numericality: { greater_than_or_equal_to: 1 }

  def perform
    balance = user.balance
    return true if balance.increase!(self.amount)

    errors.add(:base, balance.errors.full_messages)
    try(:throw, :abort)
    false
  end

  protected

  def skip_approve_on_create?
    true
  end
end
