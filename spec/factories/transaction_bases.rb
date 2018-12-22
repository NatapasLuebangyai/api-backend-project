FactoryBot.define do
  factory :transaction_basis, class: 'Transaction::Base' do
    name            { SecureRandom.urlsafe_base64 }
  end
end
