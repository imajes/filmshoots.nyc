class Location < MapType

  has_many :intersections, foreign_key: :parent_id, dependent: :destroy

  # def readable
  #   "\n > #{super}\n#{children.map(&:readable).join("\n")}"
  # end
end
