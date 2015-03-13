class AddIndexesDurrr < ActiveRecord::Migration
  def change
    add_index :categories, :name
    add_index :addresses, :geocoded
    add_index :map_types, :permit_id
    add_index :map_types, :address_id
  end
end
