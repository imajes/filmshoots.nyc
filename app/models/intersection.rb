class Intersection < MapType
  has_many :streets, foreign_key: :parent_id

  # def readable
  #   "  >> #{super}"
  # end
end
