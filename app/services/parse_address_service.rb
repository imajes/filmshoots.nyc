
# This parses an address from a permit
# via the parslet classes. Then, it triggers
# the address parsing service.

class ParseAddressService

  attr_accessor :parse_log, :permit, :force

  def initialize(permit, force=nil)
    @permit = permit
    @force = force
  end

  def process!
    return if permit.addresses.any? && force.nil?

    if permit.original_location.blank?
      msg = "Permit Failed: Skipping #{permit.id} #{permit.project.try(:title)}"
      puts msg
      parse_log.warn msg
      return
    end

    parsed_address.to_a.each { |addr| create_address(addr) }

    permit.save!
  end

  def create_address(addr)

    begin
      case addr.keys.first
      when :location
        l = addr[:location]

        @location = permit.locations.create!(original_address: "#{l[:location_title]}, #{l[:place]}")

      when :address
        @location = permit.locations.create(original_address: addr[:address])

      when :intersection
        l = addr[:intersection]

        @location = permit.locations.build if @location.nil?

        if l.has_key?(:street)
          @location = permit.locations.create(parent_id: @location.id, original_address: l[:street])
        end

        [:cross1, :cross2].each do |c|
          @location.intersections.create(parent_id: @location.id, original_address: l[c])
        end

      else
        raise Exception.new("Unexpected address thing happened... #{address.inspect}..")
      end
    rescue Exception => e
      debugger
    end
  end


  def parse_log
    @parse_log ||= Logger.new(Rails.root.join('log/parse.log'))
  end

  def parsed_address
    begin
      permit.parse_location
    rescue Parslet::ParseFailed => e
      msg = "Parse Failed: #{permit.id} #{permit.project.try(:title)} - #{e.message}"
      puts msg
      parse_log.warn msg
      return nil
    end

  end

end
