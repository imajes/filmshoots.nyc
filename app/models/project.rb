class Project < ActiveRecord::Base

  belongs_to :company

  validates :city_ref, uniqueness: true, presence: true

  def self.import(ref, title, company_name, category)

    company = Company.import(company_name)

    project = self.where(title: title, city_ref: ref).first_or_create!
    project.update(city_ref: ref, title: title, category: category)
    project.company = company

    project.save
  end

end
