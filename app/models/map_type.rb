class MapType < ActiveRecord::Base
  belongs_to :permit
  belongs_to :address

  scope :with_address, -> { joins(:address).includes(:address) }

  acts_as_nested_set

  attr_accessor :original_address

  before_save :apply_address

  def readable
    x = if address.present?
      address.geocoded? ? "#{address.formatted}" : "#{address.original}"
    else
      ' --- Address Missing --- '
    end
    "> #{self.class}: #{x}\n#{children.with_address.map(&:readable).join("   >")}"
  end

  private

  def apply_address
    return if original_address.nil?
    self.address = Address.where(original: original_address).first_or_create
  end
end
