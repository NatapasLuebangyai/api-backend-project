require 'rails_helper'

RSpec.describe Transaction::Withdraw, type: :model do
  describe 'Validations' do
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(1) }
  end

  describe 'Methods' do
    let(:user)                  { FactoryBot.create(:user) }
    let(:balance)               { user.balance }
    let(:transaction)           { FactoryBot.build(:transaction_withdraw, user: user, amount: withdraw_amount) }
    let(:withdraw_amount)       { Money.from_amount(50) }

    describe '#perform' do
      it 'should decrease balance' do
        cash = Money.from_amount(100)
        balance.update(cash: cash)
        transaction.perform

        balance.reload
        expect(balance.cash).to eq(cash - withdraw_amount)
      end

      it 'should abort if decrease balance failure' do
        cash = Money.from_amount(15)
        balance.update(cash: cash)
        transaction.perform

        balance.reload
        expect(balance.cash).to eq(cash)
      end
    end
  end
end
