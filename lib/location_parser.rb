require 'parslet'
require 'parslet/convenience'
require 'awesome_print'
require 'byebug'

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
  rule(:between) { str('between').as(:btwn) }
  rule(:the_and) { str('and').as(:and) }

  # matched literals
  rule(:letter)    { match['^[\s:,]'] }
  rule(:not_comma) { match['[^,]'] }
  rule(:not_space) { match['[^\s]'] }

  # delimiter literals
  rule(:street_delimiter) { (between | the_and) >> space? }
  rule(:colon_delimiter) { colon >> colon? >> space? }
  rule(:comma_delimiter) { space? >> (comma >> space?) | (eof | colon) }

  # streets
  rule(:street) { (letter.repeat(1) >> space?).repeat(1) }
  rule(:street_word) { letter.repeat(1).as(:word) >> space? }

  # address types
  rule(:location)     { street.as(:title) >> colon_delimiter >> street.as(:place) >> colon? >> comma_delimiter }
  rule(:intersection) { (street_delimiter | street_word).repeat(1) >> comma_delimiter }
  rule(:plain_street) { street >> comma_delimiter }
  rule(:missing_part) { comma >> space? }

  # structure
  rule(:fragment) { location.as(:location) | plain_street.as(:street) | missing_part.as(:missing)  | intersection.as(:intersection) }

  rule(:shoot_locations) { fragment.repeat(1) }

  root :shoot_locations

end

