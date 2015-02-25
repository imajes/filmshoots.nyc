class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :original_names

      t.timestamps
    end

    add_index :companies, :name
  end
end
