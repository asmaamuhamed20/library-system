FactoryBot.define do
  factory :borrowing do
    user { nil }
    book { nil }
    borrowed_at { "2024-07-24 13:14:21" }
    due_date { "2024-07-24 13:14:21" }
    returned_at { "2024-07-24 13:14:21" }
  end
end
