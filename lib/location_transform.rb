require 'parslet'
require 'parslet/convenience'
require 'awesome_print'
require 'byebug'

class LocationTransform < Parslet::Transform


  # rule(intersection: subtree(:x)) { puts x }

  rule(place: simple(:x), cross1: simple(:y), cross2: simple(:z)) {
            { street: permit.clean_street(x),
              cross1: permit.google_intersection(x, y),
              cross2: permit.google_intersection(x, z)
            }
  }

  # simple streets
  rule(street: simple(:x)) { { address: permit.clean_street(x) } }


  # locations
  rule(title: simple(:x), place: simple(:y)) { {location_title: x.to_s.strip, place: permit.clean_street(y)} }


end


