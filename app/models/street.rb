class Street < MapType
  belongs_to :location, foreign_key: :parent_id
  has_many :intersections, foreign_key: :parent_id, dependent: :destroy
end
