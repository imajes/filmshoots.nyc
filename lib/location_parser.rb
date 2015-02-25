require 'parslet'
require 'parslet/convenience'
# dev reqs
begin
  require 'awesome_print'
  require 'byebug'
rescue LoadError
end

class LocationParser < Parslet::Parser

  # simple literals
  rule(:colon)   { str(':') }
  rule(:colon?)   { colon.maybe }
  rule(:comma)   { str(',') }
  rule(:comma?)   { comma.maybe }
  rule(:space)   { str(' ') }
  rule(:space?)  { space.maybe }
  rule(:eof)     { any.absent? }

  # word matches
  rule(:between) { str('between') >> space? }
  rule(:the_and) { str('and') >> space? }

  # matched literals
  rule(:letter)    { match['^[\s:,]'] }
  rule(:upper_letter) { match['A-Z0-9 '] }
  rule(:not_comma) { match['[^,]'] }
  rule(:not_space) { match['[^\s]'] }

  # delimiter literals
  rule(:colon_delimiter) { colon >> colon? >> space? }
  rule(:comma_delimiter) { space? >> (comma >> space?) | (eof | colon) }

  # streets
  rule(:street)       { (letter.repeat(1) >> space?).repeat(1) }
  rule(:street_upper) { (upper_letter.repeat(1) >> space?).repeat(1) }

  # address types
  rule(:plain_street) { street >> comma_delimiter }
  rule(:missing_part) { (comma | colon) >> space? }

  rule(:location)     { street.as(:title) >>
                        colon_delimiter >>
                        street.as(:place) >>
                        colon? >>
                        not_comma.repeat(0) >>
                        comma_delimiter }

  rule(:intersection) { street_upper.as(:place) >>
                        between >>
                        street_upper.as(:cross1) >>
                        the_and >>
                        street_upper.as(:cross2) >>
                        comma_delimiter }

  # structure
  rule(:fragment) { location.as(:location) |
                    intersection.as(:intersection) |
                    plain_street.as(:street) |
                    missing_part.as(:missing) }

  rule(:shoot_locations) { fragment.repeat(1) }

  root :shoot_locations

end

