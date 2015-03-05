class Company < ActiveRecord::Base
  searchkick suggest: [:name]

  has_many :projects
  has_many :categories, -> { distinct('categories.name') }, through: :projects

  def original_names
    JSON.parse(attributes['original_names'] || '[]')
  end

  def original_names=(new_name)
    original_names_will_change!

    to_save = (original_names << new_name).uniq
    self[:original_names] = JSON.dump(to_save)
  end

  def search_data
    {
      name: name,
      categories: categories.map(&:name).uniq,
      project_count: projects.size
    }
  end

end
