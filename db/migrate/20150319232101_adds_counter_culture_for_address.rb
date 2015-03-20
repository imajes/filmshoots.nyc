class AddsCounterCultureForAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :map_types_count, :integer, default: 0, null: false

    add_index :addresses,  :map_types_count
    add_index :projects,   :permits_count
    add_index :companies,  :projects_count
    add_index :categories, :projects_count
  end
end
