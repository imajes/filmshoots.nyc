class Permit < ActiveRecord::Base
  include ActiveSupport::Inflector

  belongs_to :project
  has_and_belongs_to_many :addresses

  before_save :trim_nulls

  # sql/stat/grouping queries

  def self.issued_by_month
    sql = "select count(*) as count, date_trunc('month', event_start) as month, date_trunc('year', event_start) as year from permits group by year, month order by year asc, month asc"
    self.find_by_sql(sql)
  end

  def self.import(item)
    # [:event_id, :project_title, :event_name, :event_type, :event_start_date, :event_end_date, :entered_on,
    # :location, :zip, :boro, :project_id]

    item = item.to_h.symbolize_keys!
    item.values.map { |x| x.strip! unless x.nil? }

    permit = Permit.where(event_ref: item[:event_id].to_i).first_or_initialize

    permit.project = Project.where(city_ref: item[:project_id].to_i).first

    attrs = { event_name:        item[:event_name],
              event_type:        item[:event_type],
              boro:              item[:boro],
              original_location: item[:location],
              zip:               item[:zip].gsub(/,$/, ''),
              event_start:       Time.strptime(item[:event_start_date], "%m/%d/%y %H:%M %p"),
              event_end:         Time.strptime(item[:event_end_date], "%m/%d/%y %H:%M %p"),
              entered_on:        Time.strptime(item[:entered_on], "%m/%d/%y %H:%M %p")
    }

    permit.assign_attributes(attrs)
    permit.save!

  end

  def locations
    addresses.where(type: "Location")
  end

  def intersections
    addresses.where(type: "Intersection")
  end

  def zips
    zip.to_s.split(",")
  end

  def original_location_as_paragraph
    original_location.gsub(/\s+/, " ").split(",").map do |line|

      line.strip!

      if line =~ /\:/
        line = "\n#{line}"
      elsif line =~ /between/
        line = "\t#{line}".gsub("&", "_and_")
        line = line.gsub(" and ", " & ").gsub(" between ", " <> ").gsub("_and_", 'and')
      else
        line = line
      end

    end.join("\n")
  end

  def parse_location
    parsed = LocationParser.new.parse(original_location_as_paragraph)
    LocationTransform.new.apply(parsed, permit: self)
  end


  def google_intersection(street, cross)
    street = clean_street(street, :intersection)
    cross  = clean_street(cross, :intersection)

    "#{street} at #{cross}"
  end

  def clean_street(str, kind=:any)
    addr_zip  = (zips.size == 1 ? "NY #{zips.first}" : "NY")
    addr_boro = (boro.nil? ? "New York" : boro)

    if kind == :intersection
      "#{format_address(str.to_s.strip, true)}, #{addr_boro}, #{addr_zip}"
    else
      "#{format_address(str.to_s.strip)}, #{addr_boro}, #{addr_zip}"
    end
  end

  def format_address(str, strip_leading_num=false)
    if /(?<st>[0-9]+) STREET/i =~ str
      str.gsub!(/[0-9]+ STREET/i, "#{ordinalize(st)} STREET")
    end

    if /(?<ave>[0-9]+) AVE/i =~ str
      str.gsub!(/[0-9]+ AVE/i, "#{ordinalize(ave)} AVE")
    end

    str.gsub!(/^[0-9]+\s/, '') if strip_leading_num

    return str
  end

  private

  def trim_nulls
    self.zip  = nil if zip  == "NULL"
    self.boro = nil if boro == "NULL"
  end

end
