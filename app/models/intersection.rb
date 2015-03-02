class Intersection < MapType
  belongs_to :street, foreign_key: :parent_id

  # def readable
  #   "  >> #{super}"
  # end
end
