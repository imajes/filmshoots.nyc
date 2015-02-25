class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :original
      t.string :formatted
      t.string :zipcode
      t.string :neighborhood

      t.float :latitude
      t.float :longitude

      t.text   :data

      t.timestamps
    end

    add_index :addresses, :original
    add_index :addresses, :formatted
    add_index :addresses, :latitude
    add_index :addresses, :longitude
    add_index :addresses, :neighborhood
  end
end
