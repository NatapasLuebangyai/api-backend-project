require 'rails_helper'

RSpec.describe Balance, type: :model do
  describe 'Validations' do
    it { should monetize(:cash).with_currency(:usd) }
    it { should validate_numericality_of(:cash).is_greater_than_or_equal_to(0) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_many(:assets).class_name('AssetBalance').dependent(:destroy) }
  end

  describe 'Column Specifications' do
    it { should have_db_column(:cash_cents).of_type(:integer) }
    it { should have_db_column(:user_id).of_type(:integer) }
  end

  describe 'Methods' do
    let(:user)                  { FactoryBot.create(:user) }
    let(:balance)               { user.balance }

    describe '#increase' do
      it 'should increase cash' do
        amount = Money.from_amount(100)
        balance.increase(amount)
        expect(balance.cash).to eq(amount)
        expect(balance.reload.cash).to eq(0)
      end

      it 'should save if options save is true' do
        amount = Money.from_amount(100)
        balance.increase(amount, save: true)
        expect(balance.cash).to eq(amount)
        expect(balance.reload.cash).to eq(amount)
      end

      it 'should return false if value < 0' do
        amount = Money.from_amount(-1)
        expect(balance.increase(amount)).to eq(false)
        expect(balance.cash).to eq(Money.from_amount(0))
      end
    end

    describe '#increase!' do
      it 'should update increase cash' do
        amount = Money.from_amount(100)
        balance.increase!(amount)
        expect(balance.cash).to eq(amount)
        expect(balance.reload.cash).to eq(amount)
      end

      it 'should return false if value < 0' do
        amount = Money.from_amount(-1)
        expect(balance.increase!(amount)).to eq(false)
        expect(balance.cash).to eq(Money.from_amount(0))
      end
    end

    describe '#decrease' do
      before do
        balance.update(cash: 10)
      end

      it 'should decrease cash' do
        amount = Money.from_amount(3)
        balance.decrease(amount)
        expect(balance.cash).to eq(Money.from_amount(7))
        expect(balance.reload.cash).to eq(Money.from_amount(10))
      end

      it 'should save if options save is true' do
        amount = Money.from_amount(3)
        balance.decrease(amount, save: true)
        expect(balance.cash).to eq(Money.from_amount(7))
        expect(balance.reload.cash).to eq(Money.from_amount(7))
      end

      it 'should return false if value < 0' do
        amount = Money.from_amount(-1)
        expect(balance.decrease(amount)).to eq(false)
        expect(balance.cash).to eq(Money.from_amount(10))
      end

      it 'should return false if not enough cash' do
        amount = Money.from_amount(11)
        expect(balance.decrease(amount)).to eq(false)
        expect(balance.cash).to eq(Money.from_amount(10))
      end
    end

    describe '#decrease!' do
      before do
        balance.update(cash: 10)
      end

      it 'should update decrease cash' do
        amount = Money.from_amount(3)
        balance.decrease!(amount)
        expect(balance.cash).to eq(Money.from_amount(7))
        expect(balance.reload.cash).to eq(Money.from_amount(7))
      end

      it 'should return false if value < 0' do
        amount = Money.from_amount(-1)
        expect(balance.decrease!(amount)).to eq(false)
        expect(balance.cash).to eq(Money.from_amount(10))
      end

      it 'should return false if not enough cash' do
        amount = Money.from_amount(11)
        expect(balance.decrease!(amount)).to eq(false)
        expect(balance.cash).to eq(Money.from_amount(10))
      end
    end

    describe '#display_informations' do
      let!(:assets)              { (1..3).map { |i| FactoryBot.create(:asset) } }
      let!(:asset_balances)      {
        assets.map do |asset|
          FactoryBot.create(:asset_balance, balance: balance, asset: asset)
        end
      }

      before do
        balance.update(cash: 10)
      end

      it 'should return balance display information' do
        result = balance.display_informations
        expect(result[:cash]).to eq(balance.cash.format(symbol: false).to_f)
        asset_balances.each do |asset_balance|
          expect(result[asset_balance.asset.name]).to eq(asset_balance.amount)
        end
      end
    end
  end
end
