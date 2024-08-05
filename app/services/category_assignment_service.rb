class CategoryAssignmentService
  def initialize(book, category_ids)
    @book = book
    @category_ids = category_ids
  end

  def assign
    return unless @category_ids.present?
    categories = Category.where(id: @category_ids)
    @book.categories = categories
  end
end
