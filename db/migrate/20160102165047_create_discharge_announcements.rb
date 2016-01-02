class CreateDischargeAnnouncements < ActiveRecord::Migration
  def change
    create_table :discharge_announcements do |t|
      t.text :dam_dischg_code
      t.text :dam_name
      t.text :river_system_name
      t.text :river_name
      t.text :target_municipality

      t.timestamps null: false
    end
    add_index :discharge_announcements, :dam_dischg_code
    add_index :discharge_announcements, :dam_name
  end
end
