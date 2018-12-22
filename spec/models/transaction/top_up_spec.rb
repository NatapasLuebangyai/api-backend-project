require 'rails_helper'

RSpec.describe Transaction::TopUp, type: :model do
  describe 'Validations' do
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(1) }
  end

  describe 'Methods' do
    let(:user)                  { FactoryBot.create(:user) }
    let(:balance)               { user.balance }
    let(:transaction)           { FactoryBot.build(:transaction_top_up, user: user) }

    describe '#perform' do
      it 'should increase balance' do
        cash = Money.from_amount(100)
        transaction.amount = cash
        transaction.perform

        balance.reload
        expect(balance.cash).to eq(cash)
      end

      it 'should abort if increase balance failure' do
        cash = Money.from_amount(-100)
        transaction.amount = cash
        transaction.perform

        balance.reload
        expect(balance.cash).to eq(0)
      end
    end
  end
end
