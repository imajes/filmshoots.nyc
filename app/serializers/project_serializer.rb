class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :category, :permits_count, :city_ref

  def category
    object.category.try(:name)
  end
end
