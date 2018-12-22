require 'rails_helper'

RSpec.describe Asset, type: :model do
  let!(:asset)              { FactoryBot.create(:asset) }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should monetize(:price).with_currency(:usd) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

    it 'should validate uniqueness of :name with not soft deleted assets' do
      asset2 = FactoryBot.build(:asset, name: asset.name)
      expect(asset2.valid?).to eq(false)

      asset.update(soft_deleted: true)
      expect(asset2.valid?).to eq(true)
    end
  end

  describe 'Associations' do
    it { should have_many(:asset_balances).dependent(:destroy) }
  end

  describe 'Column Specifications' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_index(:name).unique(true) }
    it { should have_db_column(:soft_deleted).of_type(:boolean).with_options(default: false) }
    it { should have_db_column(:price_cents).of_type(:integer) }
  end

  describe 'Methods' do
    describe '#soft_delete!' do
      let(:user)                { FactoryBot.create(:user) }
      let(:balance)             { user.balance }
      let!(:asset2)             { FactoryBot.create(:asset) }
      let!(:asset_balance1)      { FactoryBot.create(:asset_balance, balance: balance, asset: asset) }
      let!(:asset_balance2)      { FactoryBot.create(:asset_balance, balance: balance, asset: asset2) }

      it 'should update soft_deleted to true' do
        asset.soft_delete!
        expect(asset.soft_deleted).to eq(true)
      end

      it 'should destroy all associated asset balances' do
        asset.soft_delete!
        expect(asset.reload.asset_balances).not_to be_present
      end
    end
  end

  describe 'Callbacks' do
    describe 'Beofore Destroy' do
      describe '#unable_to_destroy' do
        it 'should abort destroy' do
          asset.destroy
          expect(Asset.where(id: asset.id)).to be_present
        end

        it 'should allow destroy on attr attr accessor force_destroy' do
          asset.force_destroy = true
          asset.destroy
          expect(Asset.where(id: asset.id)).not_to be_present
        end
      end
    end
  end
end
