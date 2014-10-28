class AddGeocodedBoolToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :geocoded, :boolean, default: false
  end
end
