class AddsGeocodePrecision < ActiveRecord::Migration
  def change
    add_column :addresses, :geocoded_precision, :string, default: nil
    add_index :addresses, :geocoded_precision
  end
end
