class RemovesMapTypesCount < ActiveRecord::Migration
  def change
    remove_column :addresses, :map_types_count, :integer
  end
end
