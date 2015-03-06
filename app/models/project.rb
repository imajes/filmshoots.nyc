class Project < ActiveRecord::Base
  searchkick suggest: [:title]

  belongs_to :company
  belongs_to :category

  has_many :permits

  validates :city_ref, uniqueness: true, presence: true

  def self.all_categories
    select('category').uniq.map(&:category).sort
  end

  def self.import(ref, title, company_name, category)
    company_import = ImportCompanyService.new(company_name).process!
    category = Category.where(name: category).first_or_create!

    project = where(title: title, city_ref: ref).first_or_create!
    project.update(city_ref: ref, title: title, company: company_import.company, category: category)
  end

  def all_locations
    permits.map(&:locations).flatten
  end
end
