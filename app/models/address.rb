class Address < ActiveRecord::Base

  has_and_belongs_to_many :permits

  # before_save :geocode_address

  acts_as_nested_set


  private

  def geocode_address
    geo_results = Geocoder.search(original)

    if geo_results.any?
      geo = geo_results.first

      self.geocoded     = true
      self.formatted    = geo.formatted_address
      self.longitude    = geo.longitude
      self.latitude     = geo.latitude
      self.zipcode      = geo.postal_code
      self.neighborhood = geo.neighborhood
      self.data         = geo.data.to_json
    end
  end


end
