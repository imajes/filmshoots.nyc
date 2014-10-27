class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :original
      t.string :formatted
      t.float :lat
      t.float :lng


      t.timestamps
    end

    add_index :locations, :formatted
    add_index :locations, :lat
    add_index :locations, :lng

    create_table :locations_permits do |t|
      t.references :permit
      t.references :location
    end

    add_index :locations_permits, :permit_id
    add_index :locations_permits, :location_id


  end
end
