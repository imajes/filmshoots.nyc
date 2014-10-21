class Company < ActiveRecord::Base

  has_many :projects

  def original_names
    JSON.parse(attributes['original_names'] || "[]")
  end

  def original_names= new_name
    original_names_will_change!

    to_save = (original_names << new_name).uniq
    self[:original_names] = JSON.dump(to_save)
  end


  def self.import(name)
    orig = name.dup.strip

    name = name.downcase.strip

    rejected_terms = /(,|)\s(llc|inc|ltd)(.|)/
    name.gsub!(rejected_terms, '')

    name = name.strip.titleize

    company = self.where(name: name).first_or_create!
    company.original_names = orig
    company.save

    return company
  end

end
