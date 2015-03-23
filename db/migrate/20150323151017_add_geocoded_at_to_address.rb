class AddGeocodedAtToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :geocoded_at, :timestamp
  end
end
