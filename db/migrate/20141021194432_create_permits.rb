class CreatePermits < ActiveRecord::Migration
  def change
    create_table :permits do |t|

      t.integer    :event_ref
      t.references :project
      t.string     :event_name
      t.string     :event_type
      t.datetime   :event_start
      t.datetime   :event_end
      t.datetime   :entered_on
      t.text       :original_location
      t.string     :zip
      t.string     :boro

      t.timestamps
    end

    add_index :permits, :project_id
    add_index :permits, :event_start
    add_index :permits, :event_end
    add_index :permits, :event_type
    add_index :permits, :zip
  end
end
