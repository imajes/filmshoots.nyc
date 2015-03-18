class CompanySerializer < ActiveModel::Serializer

  attributes :name, :alternate_names, :projects

  def alternate_names
    object.original_names
  end

  def projects
    object.projects_count
  end

end
