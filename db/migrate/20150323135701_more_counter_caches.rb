class MoreCounterCaches < ActiveRecord::Migration
  def change
    add_column :addresses, :intersections_count, :integer, default: 0, null: false
    add_column :addresses, :locations_count, :integer, default: 0, null: false

    add_index :addresses, :intersections_count
    add_index :addresses, :locations_count
  end
end
