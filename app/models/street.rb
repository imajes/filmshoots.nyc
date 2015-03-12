class Street < MapType
  belongs_to :intersection, foreign_key: :parent_id
end
