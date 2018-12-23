require 'rails_helper'

RSpec.describe Transaction::Base, type: :model do
  let(:user)                  { FactoryBot.create(:user) }
  let!(:transaction)          { FactoryBot.create(:transaction_basis, user: user) }

  describe 'Validations' do
    it { should validate_presence_of(:name).on(:update) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_most(30) }
    it { should monetize(:amount).with_currency(:usd) }
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:asset) }
  end

  describe 'Column Specifications' do
    it { should have_db_column(:amount_cents).of_type(:integer) }
    it { should have_db_column(:name).of_type(:string).with_options(limit: 30, null: false) }
    it { should have_db_column(:approved).of_type(:boolean).with_options(null: true) }
    it { should have_db_column(:type).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:asset_id).of_type(:integer) }
    it { should have_db_index(:name).unique(true) }
  end

  describe 'Methods' do
    describe '#approve' do
      before do
        transaction.update(approved: nil)
      end

      it 'should assign approved to true' do
        transaction.approve
        expect(transaction.approved).to eq(true)
        expect(transaction.reload.approved).not_to eq(true)
      end
    end

    describe '#approve!' do
      before do
        transaction.update(approved: nil)
      end

      it 'should update approved to true' do
        transaction.approve!
        expect(transaction.approved).to eq(true)
        expect(transaction.reload.approved).to eq(true)
      end
    end

    describe '#reject' do
      before do
        transaction.update(approved: nil)
      end

      it 'should assign approved to false' do
        transaction.reject
        expect(transaction.approved).to eq(false)
        expect(transaction.reload.approved).not_to eq(false)
      end
    end

    describe '#reject!' do
      before do
        transaction.update(approved: nil)
      end

      it 'should update approved to false' do
        transaction.reject!
        expect(transaction.approved).to eq(false)
        expect(transaction.reload.approved).to eq(false)
      end
    end

    describe '#display_informations' do
      it 'should return hash of display informations' do
        result = transaction.display_informations
        expect(result[:id]).to eq(transaction.id)
        expect(result[:name]).to eq(transaction.name)
        expect(result[:type]).to eq(transaction.class.to_s.demodulize.underscore)
        expect(result[:amount]).to eq(transaction.amount.format(symbol: false))
        expect(result[:created_at]).to eq(transaction.created_at)
      end
    end
  end

  describe 'Callbacks' do
    let(:transaction)          { FactoryBot.build(:transaction_basis, user: user) }

    describe 'Before Validations' do
      describe '#set_amount_form_price' do
        let(:asset)                { FactoryBot.create(:asset, price: 25) }

        it 'should set amount to equal asset price' do
          transaction.asset = asset
          transaction.save
          expect(transaction.amount).to eq(asset.price)
        end

        it 'should not set if no asset' do
          transaction.save
          expect(transaction.amount).to eq(0)
        end
      end

      describe '#generate_name' do
        it 'should generate name if name is blank' do
          transaction.save
          expect(transaction.name).to be_present
        end

        it 'should not generate name if name is present' do
          transaction.name = 'transactionname'
          expect(transaction.name).to eq('transactionname')
        end

        it 'should generate name only on create' do
          transaction.save
          transaction_name = transaction.name
          transaction.save
          expect(transaction.reload.name).to eq(transaction_name)
        end
      end
    end

    describe 'Before Create' do
      describe '#try_perform' do
        it 'should set approved to true' do
          transaction.save
          expect(transaction.reload.approved).to eq(true)
        end

        it 'should skip if skip_perform_on_create is true' do
          transaction.skip_perform_on_create = true
          transaction.save
          expect(transaction.reload.approved).not_to eq(true)
        end
      end
    end
  end
end
