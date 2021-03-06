class Category < ActiveRecord::Base
  has_many :projects
  has_many :companies, -> { distinct('companies.name') }, through: :projects
end
