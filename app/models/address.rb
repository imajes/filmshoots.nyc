class Address < ActiveRecord::Base

  has_and_belongs_to_many :permits

  # before_save :geocode_address

  acts_as_nested_set

  def self.process_parsed(list, permit)
    list = [list] unless list.is_a?(Array)

    list.to_a.each do |addr|
      handle_parsed_item(addr, permit)
    end

    permit.save

  end

  def self.handle_parsed_item(addr, permit)

    begin
    case addr.keys.first
    when :location
      l = addr[:location]

      @location = Location.create(original: "#{l[:location_title]}, #{l[:place]}")
      permit.addresses << @location

    when :address
      @location = Location.create(original: addr[:address])
      permit.addresses << @location

    when :intersection
      l = addr[:intersection]

      @location = Location.new if @location.nil?

      if l.has_key?(:street)
        @location = Location.create(parent_id: @location.id, original: l[:street])
        permit.addresses << @location
      end

      [:cross1, :cross2].each do |c|
        ins = Intersection.create(parent_id: @location.id, original: l[c])
        permit.addresses << ins
      end

    else
      raise Exception.new("Unexpected address thing happened... #{address.inspect}..")
    end

    rescue => e
      debugger
      puts e
    end
  end

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
