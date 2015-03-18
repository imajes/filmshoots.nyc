class AddCounterCaches < ActiveRecord::Migration
  def change
    add_column :projects,   :permits_count,  :integer, default: 0, null: false
    add_column :companies,  :projects_count, :integer, default: 0, null: false
    add_column :categories, :projects_count, :integer, default: 0, null: false
  end
end
