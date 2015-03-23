class Intersection < MapType
  has_many :streets, foreign_key: :parent_id, dependent: :destroy

  counter_culture :address
end
