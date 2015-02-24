class MapType < ActiveRecord::Base


  belongs_to :permit
  belongs_to :address

  acts_as_nested_set
end
