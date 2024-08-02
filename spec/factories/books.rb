FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    isbn { Faker::Code.isbn }
    description { Faker::Lorem.paragraph }
    published_date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
    after(:create) do |book|
      create(:categorization, book: book, category: create(:category))
    end
  end
end
