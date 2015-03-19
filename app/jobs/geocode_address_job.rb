class GeocodeAddressJob
  include Sidekiq::Worker

  # errors: https://github.com/mperham/sidekiq/wiki/Error-Handling
  # Location.joins(:address).where("addresses.geocoded": false)

  def perform(address_id)
    begin
      a = Address.not_geocoded.find(address_id)
      a.geocode!

      Rails.logger.info "Geocoding: #{a.id} - #{a.original}/#{a.formatted} - Used: #{MapType.where(address_id: a.id).count}"

      a.save if a.changed?
      sleep(rand(0..6))
    rescue ActiveRecord::RecordNotFound
      # already geocoded, so skip this step
      Rails.logger.warn "Geocoding: Already done - #{address_id}!"
      true
    rescue Geocoder::RequestDenied
      self.class.perform_in((12.hours + rand(1..360).minutes), address_id)
      Rails.logger.warn "Geocoding: Google denied request for #{a.id} :( #{a.original}...!"
    end
  end
end
