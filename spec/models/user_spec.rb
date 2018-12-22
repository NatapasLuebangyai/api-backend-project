require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:balance).on(:update) }
  end

  describe 'Associations' do
    it { should have_one(:balance).validate(true).dependent(:destroy) }
  end

  describe 'Callbacks' do
    describe 'After Create' do
      describe '#create_balance' do
        let(:user)               { FactoryBot.build(:user) }
        let(:balance)            { FactoryBot.build(:balance) }

        it 'should not create balance if present' do
          user.balance = balance
          user.save
          expect(user.balance).to eq(balance)
        end

        it 'should create balance if not present' do
          user.save
          expect(user.balance).to be_present
        end
      end
    end
  end
end
