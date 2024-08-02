FactoryBot.define do
  factory :categorization do
    association :book
    association :category
  end
end
