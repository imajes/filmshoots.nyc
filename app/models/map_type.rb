class MapType < ActiveRecord::Base

  belongs_to :permit
  belongs_to :address

  acts_as_nested_set

  attr_accessor :original_address

  before_save :apply_address

  private
  def apply_address
    return if original_address.nil?
    self.address = Address.where(original: original_address).first_or_create
  end
end
