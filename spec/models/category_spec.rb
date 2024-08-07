require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should have_many(:categorizations) }
  it { should have_many(:books).through(:categorizations) }
  it { should validate_presence_of(:name) }

  describe 'Custom Behavior' do
    let(:category) { Category.new(name: 'Science Fiction') }

    it 'is valid with valid attributes' do
      expect(category).to be_valid
    end

    it 'is not valid without a name' do
      category.name = nil
      expect(category).not_to be_valid
    end
  end
end
