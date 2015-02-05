require 'parslet'
require 'parslet/convenience'
require 'awesome_print'
require 'byebug'

class LocationParser < Parslet::Parser

  # simple literals
  rule(:colon)   { str(':') }
  rule(:comma)   { str(',') }
  rule(:comma?)   { comma.maybe }
  rule(:space)   { str(' ') }
  rule(:space?)  { space.maybe }
  rule(:blank)   { str('')  }
  rule(:punct)   { str('&') }
  rule(:punct?)  { punct.maybe }

  # word matches
  rule(:between) { str('between').as(:btwn) }
  rule(:the_and) { str('and').as(:and) }

  # matched literals
  rule(:tab)       { match['\t'] }
  rule(:word)      { match['\w\-\(\)\.\' /'] }
  rule(:letter)      { match['\S'] }
  rule(:not_comma) { match['[^,]'] }
  rule(:not_space) { match['[^\s]'] }

  # composite literals

  rule(:street_delimiter) { (between | the_and) >> space? }

  rule(:comma_space) { comma? >> space? }
  rule(:newline)     { str("\r").maybe >> str("\n") }

  # grammar structure
  rule(:street) { (letter.repeat(1) >> space?).repeat(1) }

  # composite location start
  rule(:location) { street.as(:location_title) >> colon >> colon.maybe >> street.as(:place) >> colon.maybe }

  rule(:street_word) { letter.repeat(1).as(:word) >> space? }
  rule(:intersection) { (street_delimiter | street_word).repeat(1) }

  rule(:fragment_types) { location.as(:location) | intersection.as(:intersection) }

  rule(:fragment) { (fragment_types.repeat(1) >> space?).repeat(1) >> comma_space }

  rule(:chunks) { (not_space.repeat(1) >> space?).repeat(1) >> comma_space) }

  rule(:graf_ast) { chunks.as(:part).repeat(1) }

  root :graf_ast

  rule(:sentence_captures) { sentence_words.capture(:parts) >>
                             dynamic { |src,ctx| debugger; str('a') }
                            }


end

