FactoryBot.define do
  sequence(:email)               { |n| "user#{n}@example.com" }

  factory :user do
    email                        { FactoryBot.generate(:email) }
    password                     { "testpassword" }
    password_confirmation        { password }
  end
end
