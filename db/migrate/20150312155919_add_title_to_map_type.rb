class AddTitleToMapType < ActiveRecord::Migration
  def change
    add_column :map_types, :title, :string
  end
end
