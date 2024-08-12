FactoryBot.define do
  factory :review do
    user 
    book 
    rating { 5 }
    comment { "good" }
  end
end
