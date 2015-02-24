class Intersection < MapType

  belongs_to :location, foreign_key: :parent_id

end
