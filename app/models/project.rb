class Project < ActiveRecord::Base
  searchkick suggest: [:title]

  belongs_to :company
  belongs_to :category

  counter_culture :company
  counter_culture :category

  has_many :permits

  validates :city_ref, uniqueness: true, presence: true

  def self.import(ref, title, company_name, category)
    company_import = ImportCompanyService.new(company_name)
    company_import.process!
    category = Category.where(name: category).first_or_create!

    project = where(title: title, city_ref: ref).first_or_initialize
    project.update(city_ref: ref, title: title, company: company_import.company,
                  category: category)

    return project
  end

  def all_locations
    permits.map(&:locations).flatten
  end
end
