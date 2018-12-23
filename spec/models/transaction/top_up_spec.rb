require 'rails_helper'

RSpec.describe Transaction::TopUp, type: :model do
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

      it 'should return false if increase balance failure' do
        cash = Money.from_amount(-100)
        transaction.amount = cash

        result = transaction.perform
        expect(result).to eq(false)
        expect(transaction.errors).to be_present

        balance.reload
        expect(balance.cash).to eq(0)
      end
    end
  end
end
