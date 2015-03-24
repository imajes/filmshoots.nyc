class Address < ActiveRecord::Base
  has_many :map_types

  scope :geocoded, -> { where(geocoded: true) }
  scope :not_geocoded, -> { where(geocoded: false) }

  validates :original, uniqueness: { case_sensitive: false, message: 'Address already exists!' }

  before_validation :clean_original
  before_save :start_geocode_job, unless: :geocoded?

  def geocode!
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

      self.geocoded_at = Time.now
      self.geocoded_precision = geo.precision
    end
  end

  def coordinates
    [latitude, longitude] unless longitude.nil?
  end

  private

  def start_geocode_job
    GeocodeAddressJob.perform_async(id)
  end

  def clean_original
    self.original.gsub!(/\s+/, ' ')
  end

end
