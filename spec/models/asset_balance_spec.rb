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
end
