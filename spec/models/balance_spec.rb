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
end
