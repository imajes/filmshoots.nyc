class Address < ActiveRecord::Base
  has_many :map_types

  before_save :geocode_address

  scope :geocoded, -> { where(geocoded: true) }
  scope :not_geocoded, -> { where(geocoded: false) }


  private

  def geocode_address
    return if geocoded?
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
