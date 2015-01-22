require 'parslet'
require 'parslet/convenience'
require 'awesome_print'
require 'byebug'

class LocationParser < Parslet::Parser

  # Monsignor McGolrick Park: Monsignor McGolrick Park , REVIEW AVENUE between 35 STREET and BORDEN AVENUE, REVIEW AVENUE between 35 STREET and BORDEN AVENUE, STARR AVENUE between VAN DAM STREET and BORDEN AVENUE,
  # Silvercup Studios East: 34-02 Starr Avenue , NORTH HENRY STREET between NASSAU AVENUE and NORMAN AVENUE, RUSSELL STREET between NASSAU AVENUE and DRIGGS AVENUE, NASSAU AVENUE between HUMBOLDT STREET and RUSSELL STREET,
  # RUSSELL STREET between NASSAU AVENUE and NORMAN AVENUE
  #

  # literals
  rule(:colon)   { str(':') }
  rule(:comma)   { str(',') }
  rule(:space)   { str(' ') }
  rule(:space?)  { space.maybe }
  rule(:blank)   { str('')  }
  rule(:tab)     { match['\t'] }
  rule(:word)    { match['\w\-\(\)\.\' /'] }

  # composite literals
  rule(:between) { space? >> str('<>') >> space? }
  rule(:the_and) { space? >> str('&') >> space? }
  rule(:newline) { str("\r").maybe >> str("\n") }

  # grammar structure
  rule(:street) { (word.repeat(1) >> space?).repeat(1) }

  # composite location start
  rule(:location) { street.as(:location_title) >> colon >> colon.maybe >> street.as(:place) >> colon.maybe }

  # between streets
  rule(:address)   { tab >> street.as(:street) >> between >> street.as(:cross1) >> the_and >> street.as(:cross2) }

  # a line
  rule(:sentence_parts)  { location.as(:location) | address.as(:intersection) | street.as(:address) | newline }
  rule(:line)           { newline.maybe >> sentence_parts >> newline.maybe }

  # composed strings
  rule(:entire_graf) { line.repeat }

  root :entire_graf

end

