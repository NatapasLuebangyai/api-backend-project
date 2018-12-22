FactoryBot.define do
  sequence(:name)               { |n| "name#{n}" }

  factory :asset do
    name                        { FactoryBot.generate(:name) }
  end
end
