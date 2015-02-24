class CreateMapTypes < ActiveRecord::Migration
  def change
    create_table :map_types do |t|
      t.string :type
      t.references :address
      t.references :permits

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps null: false
    end

    add_index :map_types, :type
    add_index :map_types, :parent_id
    add_index :map_types, :lft
    add_index :map_types, :rgt
  end
end
