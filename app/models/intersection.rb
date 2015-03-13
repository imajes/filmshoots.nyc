class Intersection < MapType
  has_many :streets, foreign_key: :parent_id

end
