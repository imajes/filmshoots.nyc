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

    company = Company.import(company_name)
    category = Category.where(name: category).first_or_create!

    project = self.where(title: title, city_ref: ref).first_or_create!
    project.update(city_ref: ref, title: title, company: company, category: category)
  end

  def all_locations
    permits.map(&:locations).flatten
  end

end
