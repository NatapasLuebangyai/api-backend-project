require 'rails_helper'

RSpec.describe AssetBalance, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end

  describe 'Associations' do
    it { should belong_to(:asset) }
    it { should belong_to(:balance) }
  end

  describe 'Column Specifications' do
    it { should have_db_column(:amount).of_type(:integer).with_options(null: false, default: 0) }
  end

  describe 'Methods' do
    let(:user)                  { FactoryBot.create(:user) }
    let(:balance)               { user.balance }
    let(:asset)                 { FactoryBot.create(:asset) }
    let!(:asset_balance)        { FactoryBot.create(:asset_balance, asset: asset, balance: balance) }

    describe '#increase' do
      it 'should increase amount' do
        asset_balance.increase(5)
        expect(asset_balance.amount).to eq(5)
        expect(asset_balance.reload.amount).to eq(0)
      end

      it 'should save if options save is true' do
        asset_balance.increase(5, save: true)
        expect(asset_balance.amount).to eq(5)
        expect(asset_balance.reload.amount).to eq(5)
      end

      it 'should return false if value < 0' do
        expect(asset_balance.increase(-5)).to eq(false)
        expect(asset_balance.amount).to eq(0)
      end
    end

    describe '#increase!' do
      it 'should update increase amount' do
        asset_balance.increase!(5)
        expect(asset_balance.amount).to eq(5)
        expect(asset_balance.reload.amount).to eq(5)
      end

      it 'should increase by 1 if not pass value' do
        asset_balance.increase!
        expect(asset_balance.amount).to eq(1)
        expect(asset_balance.reload.amount).to eq(1)
      end

      it 'should return false if value < 0' do
        expect(asset_balance.increase!(-5)).to eq(false)
        expect(asset_balance.amount).to eq(0)
      end
    end

    describe '#decrease' do
      before do
        asset_balance.update(amount: 10)
      end

      it 'should decrease amount' do
        asset_balance.decrease(5)
        expect(asset_balance.amount).to eq(5)
        expect(asset_balance.reload.amount).to eq(10)
      end

      it 'should save if options save is true' do
        asset_balance.decrease(5, save: true)
        expect(asset_balance.amount).to eq(5)
        expect(asset_balance.reload.amount).to eq(5)
      end

      it 'should return false if value < 0' do
        expect(asset_balance.decrease(-5)).to eq(false)
        expect(asset_balance.amount).to eq(10)
      end

      it 'should return false if not enough amount' do
        expect(asset_balance.decrease(11)).to eq(false)
        expect(asset_balance.amount).to eq(10)
      end
    end

    describe '#decrease!' do
      before do
        asset_balance.update(amount: 10)
      end

      it 'should decrease amount' do
        asset_balance.decrease!(5)
        expect(asset_balance.amount).to eq(5)
        expect(asset_balance.reload.amount).to eq(5)
      end

      it 'should decrease by 1 if not pass value' do
        asset_balance.decrease!
        expect(asset_balance.amount).to eq(9)
        expect(asset_balance.reload.amount).to eq(9)
      end

      it 'should return false if value < 0' do
        expect(asset_balance.decrease!(-5)).to eq(false)
        expect(asset_balance.amount).to eq(10)
      end

      it 'should return false if not enough amount' do
        expect(asset_balance.decrease!(11)).to eq(false)
        expect(asset_balance.amount).to eq(10)
      end
    end
  end
end
