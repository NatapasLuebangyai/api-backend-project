require 'rails_helper'

RSpec.describe Transaction::Sell, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:asset) }
  end

  describe 'Methods' do
    let(:user)                  { FactoryBot.create(:user) }
    let(:balance)               { user.balance }
    let(:asset)                 { FactoryBot.create(:asset, price: 25) }
    let(:asset_balance)         { FactoryBot.create(:asset_balance, balance: balance, asset: asset) }
    let(:transaction)           { FactoryBot.build(:transaction_sell, user: user, asset: asset) }

    describe '#perform' do
      it 'should decrease asset balance and increase balance' do
        asset_balance.update(amount: 1)
        transaction.perform

        balance.reload
        asset_balance.reload
        expect(balance.cash).to eq(asset.price)
        expect(asset_balance.amount).to eq(0)
      end

      it 'should return false if decrease balance asset failure' do
        asset_balance.update(amount: 0)

        result = transaction.perform
        expect(result).to eq(false)
        expect(transaction.errors).to be_present

        balance.reload
        asset_balance.reload
        expect(balance.cash).to eq(0)
        expect(asset_balance.amount).to eq(0)
      end
    end
  end
end
