class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|

      t.integer :city_ref
      t.string :title
      t.string :category

      t.references :company

      t.timestamps
    end

    add_index :projects, :city_ref
    add_index :projects, :category
    add_index :projects, :company_id
    add_index :projects, :title
  end
end
