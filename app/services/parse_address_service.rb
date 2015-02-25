
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
    return if permit.locations.any? && force.nil?

    if permit.original_location.blank?
      msg = "Permit Failed: #{permit.id} missing location #{permit.project.try(:title)}"
      parse_log.warn msg
      return
    end

    parsed_address.to_a.each { |addr| create_address(addr) }

    permit.save!
  end

  def create_address(addr)
    case addr.keys.first
    when :missing
      return
    when :location
      l = addr[:location]

      @location = permit.locations.create(original_address: "#{l[:location_title]}, #{l[:place]}")

    when :address
      @location = permit.locations.create(original_address: addr[:address])

    when :intersection
      l = addr[:intersection]

      @location = permit.locations.build if @location.nil?

      if l.key?(:street)
        @location = permit.locations.create(parent_id: @location.id, original_address: l[:street])
      end

      [:cross1, :cross2].each do |c|
        @location.intersections.create(parent_id: @location.id, original_address: l[c])
      end

    else
      fail "Unexpected address thing happened... #{@location.inspect}.."
    end
  rescue Exception => e
    debugger
  end

  def parse_log
    @parse_log ||= Logger.new(Rails.root.join('log/parse.log'))
  end

  def parsed_address
    permit.parse_location
  rescue Parslet::ParseFailed => e
    msg = "Parse Failed: #{permit.id} #{permit.project.try(:title)} - #{e.message}"
    parse_log.warn msg
    return nil
  end
end
