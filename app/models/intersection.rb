class Intersection < MapType
  has_one  :street, foreign_key: :parent_id
  has_many :cross_streets, foreign_key: :parent_id

  # def readable
  #   "  >> #{super}"
  # end
end
