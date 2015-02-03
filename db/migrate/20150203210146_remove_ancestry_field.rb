class RemoveAncestryField < ActiveRecord::Migration
  def change
    remove_column :addresses, :ancestry
  end
end
