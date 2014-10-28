class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :type
      t.string :original
      t.string :formatted
      t.string :zipcode
      t.string :neighborhood

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.float :latitude
      t.float :longitude

      t.text   :data

      t.timestamps
    end

    add_index :addresses, :original
    add_index :addresses, :formatted
    add_index :addresses, :type
    add_index :addresses, :parent_id
    add_index :addresses, :lft
    add_index :addresses, :rgt
    add_index :addresses, :latitude
    add_index :addresses, :longitude
    add_index :addresses, :neighborhood

    create_table :addresses_permits do |t|
      t.references :permit
      t.references :address
    end

    add_index :addresses_permits, :permit_id
    add_index :addresses_permits, :address_id


  end
end
