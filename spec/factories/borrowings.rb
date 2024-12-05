FactoryBot.define do
  factory :borrowing do
    user
    book
    borrowed_at { Time.now }
    due_date { Time.now + 7.days }
    returned_at { Time.now + 14.days } 
  end
end
