FactoryBot.define do
  sequence(:name)               { |n| "name#{n}" }

  factory :asset do
    name                        { FactoryBot.generate(:name) }
    price                       { 1000 }
  end
end
