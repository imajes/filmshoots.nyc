class Location < MapType

  has_many :intersections, foreign_key: :parent_id

end
