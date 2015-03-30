class AddFocusedIndices < ActiveRecord::Migration
  def change
    add_index :map_types, [:type, :permit_id, :parent_id]
  end
end
