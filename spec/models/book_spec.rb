require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:published_date) }
    it { should validate_uniqueness_of(:isbn) }
  end

  describe 'associations' do
    it { should have_many(:categorizations).dependent(:destroy) }
    it { should have_many(:categories).through(:categorizations) }
    it { should have_many(:borrowings) }
  end

  describe '.create_with_categories' do
    let(:category1) { create(:category) }
    let(:category2) { create(:category) }
    let(:valid_attributes) { attributes_for(:book) }

    it 'creates a new book with associated categories' do
      book = Book.create_with_categories(valid_attributes, [category1.id, category2.id])
      expect(book).to be_persisted
      expect(book.categories).to include(category1, category2)
    end
  end

  describe '#update_with_categories' do
    let(:book) { create(:book) }
    let(:category1) { create(:category) }
    let(:category2) { create(:category) }
    let(:new_attributes) { { title: 'Updated Title' } }

    it 'updates the book and assigns new categories' do
      result = book.update_with_categories(new_attributes, [category1.id, category2.id])
      book.reload
      expect(book.title).to eq('Updated Title')
      expect(book.categories).to include(category1, category2)
      expect(result[:status]).to eq(:ok)
    end

    it 'returns errors when update fails' do
      invalid_attributes = { title: '' }
      result = book.update_with_categories(invalid_attributes, [category1.id, category2.id])
      expect(result[:status]).to eq(:unprocessable_entity)
      expect(result[:errors]).to include("Title can't be blank")
    end
  end
end
