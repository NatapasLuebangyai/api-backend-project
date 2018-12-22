require 'rails_helper'

RSpec.describe Transaction::Buy, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:asset) }
  end

  describe 'Methods' do
    let(:user)                  { FactoryBot.create(:user) }
    let(:balance)               { user.balance }
    let(:asset)                 { FactoryBot.create(:asset, price: 25) }
    let(:transaction)           { FactoryBot.build(:transaction_buy, user: user, asset: asset) }

    describe '#perform' do
      it 'should decrease balance and increase asset balance' do
        cash = Money.from_amount(100)
        balance.update(cash: cash)
        transaction.perform

        balance.reload
        expect(balance.cash).to eq(cash - asset.price)
        asset_balance = balance.assets.find_by(asset_id: asset.id)
        expect(asset_balance.amount).to eq(1)
      end

      it 'should abort if decrease balance failure' do
        balance.update(cash: 0)
        transaction.perform

        balance.reload
        expect(balance.cash).to eq(0)
        expect(balance.assets.where(asset_id: asset.id)).not_to be_present
      end
    end
  end
end
