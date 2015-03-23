
# This parses an address from a permit
# via the parslet classes. Then, it triggers
# the address parsing service.

class ParseAddressService
  attr_accessor :parse_log, :permit, :force

  def self.run!(item, force=nil)
    new(item, force).process!
  end

  def initialize(permit, force=nil)
    @permit = permit
    @force = force
  end

  def process!
    return false if permit.locations.any? && !force

    if permit.original_location.blank?
      msg = "Permit Failed: #{permit.id}. missing location for #{permit.project.try(:title)} - #{permit.original_location}"
      parse_log.warn msg
      return false
    end

    parsed_address.each { |addr| create_address(addr.keys.first, addr) }

    permit.save!
  end

  def create_address(type, addr)
    case type
    when :missing
      return false
    when :location
      l = addr[:location]

      @location = create_location(l[:location_title], "#{l[:location_title]}, #{l[:place]}")

    when :address
      @location = create_location(nil, addr[:address])

    when :intersection
      l = addr[:intersection]
      @intersection = permit.intersections.create(original_address: l[:street])

      [:cross1, :cross2].each do |c|
        @intersection.streets.create(original_address: l[c])
      end

      return @intersection
    else
      fail "Unexpected address thing happened... #{addr.inspect}.."
    end
  end

  def create_location(name, addr)
    permit.locations.create(title: name, original_address: addr)
  end

  def parse_log
    @parse_log ||= Logger.new(Rails.root.join('log/parse.log'))
  end

  def parsed_address
    permit.parse_location
  rescue Parslet::ParseFailed => e
    msg = "Parse Failed: #{permit.id} #{permit.project.try(:title)} - #{e.message}"
    parse_log.warn msg
    return []
  end
end
