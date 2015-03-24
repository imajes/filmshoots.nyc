class GeocodeAddressJob
  include Sidekiq::Worker

  # errors: https://github.com/mperham/sidekiq/wiki/Error-Handling
  # Location.joins(:address).where("addresses.geocoded": false)

  def perform(address_id)
    begin
      over_query_limit?

      a = Address.not_geocoded.find(address_id)
      a.geocode!

      logger.info "Geocoding: #{a.id} - #{a.original}/#{a.formatted} - Used: #{MapType.where(address_id: a.id).count}"

      a.save if a.changed?
      sleep(rand(0..10))
    rescue ActiveRecord::RecordNotFound
      # already geocoded, so skip this step
      logger.warn "Geocoding: Already done - #{address_id}!"
      true
    rescue Geocoder::RequestDenied
      self.class.perform_in((12.hours + rand(1..360).minutes), address_id)
      logger.warn "Geocoding: Google denied request for #{a.id} :( #{a.original}...!"
    rescue Geocoder::OverQueryLimitError
      delta = 12.hours + rand(1..360).minutes
      self.class.perform_in(delta, address_id)
      logger.warn "Geocoding: Over Query limit, pausing until #{delta.from_now}."
      reached_limit!
    end

  end

  def over_query_limit?
    raise Geocoder::OverQueryLimitError if Sidekiq.redis { |x| x.exists('geocoder_over_query_limit') }
  end

  def reached_limit!
    Sidekiq.redis do |x|
      x.set('geocoder_over_query_limit', 'true')
      x.expireat('geocoder_over_query_limit', 6.hours.from_now.to_i)
    end
  end
end
