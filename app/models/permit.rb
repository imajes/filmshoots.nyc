class Permit < ActiveRecord::Base
  include ActiveSupport::Inflector

  belongs_to :project

  counter_culture :project

  has_many :map_types

  has_many :locations,     dependent: :destroy
  has_many :intersections, dependent: :destroy

  # has_many :addresses, through: :map_types

  before_save :trim_nulls

  # sql/stat/grouping queries

  def self.issued_by_month
    sql = "select count(*) as count, date_trunc('month', event_start) as month, date_trunc('year', event_start) as year
           from permits group by year, month order by year asc, month asc"
    find_by_sql(sql)
  end

  def zips
    zip.to_s.split(',').map(&:strip)
  end

  def original_location
    # clean the extra whitespace
    attributes['original_location'].gsub(/\s+/, ' ') if attributes['original_location']
  end

  def original_location_as_paragraph
    original_location.gsub(/\s+/, ' ').split(',').map do |line|
      line.strip!

      if line =~ /\:/
        line = "\n#{line}"
      elsif line =~ /between/
        line = "\t#{line}".gsub('&', '_and_')
        line = line.gsub(' and ', ' & ').gsub(' between ', ' <> ').gsub('_and_', 'and')
      else
        line = line
      end
    end.join("\n")
  end

  def present_locations
    [locations.with_address.roots + intersections.with_address.roots].flatten.map(&:readable).join("\n")
  end

  def readable(attr)
    send(attr).with_address.roots.flatten.map(&:readable).join("\n")
  end

  def parse_location
    nil if original_location.blank?
    parsed = LocationParser.new.parse(original_location)
    LocationTransform.new.apply(parsed, permit: self)
  end

  def google_intersection(street, cross)
    street = clean_street(street, :intersection)
    cross  = clean_street(cross, :intersection)

    "#{street} at #{cross}"
  end

  def reparse_street?(str)
    if str.match /\sbetween\s/
      str = str.to_s.upcase.gsub(" BETWEEN ", " between ").gsub(" AND ", ' and ')
      LocationTransform.new.apply(LocationParser.new.parse(str), permit: self).first
    else
      { address: clean_street(str) }
    end
  end

  def clean_street(str, kind=:any)
    addr_zip  = (zips.size == 1 ? "NY #{zips.first}" : 'NY')
    addr_boro = (boro.nil? ? 'New York' : boro)

    # clean string, remove commas and trailing spaces
    str = str.to_s.gsub(',', '').strip

    if kind == :intersection
      "#{format_address(str, true)}, #{addr_boro}, #{addr_zip}"
    else
      "#{format_address(str)}, #{addr_boro}, #{addr_zip}"
    end
  end

  def format_address(str, strip_leading_num=false)
    if /(?<st>[0-9]+) (?<type>(ROAD|PLACE|DRIVE|STREET|AVE))/i =~ str
      str.gsub!(/[0-9]+ #{type}/i, "#{ordinalize(st)} #{type.upcase}")
    end

    # removes leading place numbers
    str.gsub!(/^[0-9]+\s/, '') if strip_leading_num

    str
  end

  private

  def trim_nulls
    self.zip  = nil if zip  == 'NULL'
    self.boro = nil if boro == 'NULL'
  end
end
