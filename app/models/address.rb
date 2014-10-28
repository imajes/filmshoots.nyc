class Address < ActiveRecord::Base

  has_and_belongs_to_many :permits

  has_ancestry

  before_save :geocode_address

  def self.process_parsed(list, permit)

    debugger

    list.each do |addr|

      case addr.keys.first
      when :location
        l = addr[:location]

        @location = Location.create(original: "#{l[:location_title]}, #{l[:place]}")
        permit.addresses << @location

      when :address
        l = addr[:address]

        @location = Location.create(original: l[:address])
        permit.addresses << @location

      when :intersection
        l = addr[:intersection]

        @location = Location.new if @location.nil?

        if l.has_key?(:street)
          @location = Location.create(parent: @location, original: l[:street])
          permit.addresses << @location
        end

        [:cross1, :cross2].each do |c|
          ins = Intersection.create(parent: @location, original: l[c])
          permit.addresses << ins
        end

      else
        raise Exception.new("Unexpected address thing happened... #{address.inspect}..")
      end
    end

    permit.save

  end

  private

  def geocode_address
    geocoded = Geocoder.search(original).first
    self.formatted    = geocoded.formatted_address
    self.longitude    = geocoded.longitude
    self.latitude     = geocoded.latitude
    self.zipcode      = geocoded.postal_code
    self.neighborhood = geocoded.neighborhood
    self.data         = geocoded.data.to_json
  end


end
