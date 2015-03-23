class Location < MapType
  has_many :intersections, foreign_key: :parent_id, dependent: :destroy

  counter_culture :address

  scope :distinct_group, -> { joins(:address).where("title != original").group("title, map_types.id") } 
  scope :grouped_order, -> { order("count_all desc").count }
end
