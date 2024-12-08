class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_id"

  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true, length: { in: 1..50 }, uniqueness: { 
    scope: :parent_id,
    message: "同一父分类下的子分类名称不能重复" }

  validate :no_circular_reference

  def all_children_ids
    sub_categories.pluck(:id) + sub_categories.flat_map(&:all_children_ids).flatten
  end

  def all_parent_ids
    return [] unless parent
    [parent_id] + parent.all_parent_ids
  end
  
  def self.available_parents_for(category)
    if category.new_record?
      all
    else
      where.not(id: [category.id] + category.all_children_ids)
    end
  end

  def full_path
    parent ? "#{parent.full_path} > #{name}" : name
  end

  def full_name
    if parent
      "#{name} (位于: #{parent.full_path})"
    else
      "#{name} (根分类)"
    end
  end

  private
  def no_circular_reference
    if parent_id.present?
      if parent_id == id
        errors.add(:parent_id, "不能选择自己作为父分类")
      elsif all_parent_ids.include?(id)
        errors.add(:parent_id, "不能形成循环引用")
      end
    end
  end

end
