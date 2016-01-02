class CreateDischargeAnnouncementTargetedMunicipalities < ActiveRecord::Migration
  def change
    create_table :discharge_announcement_targeted_municipalities do |t|
      t.references :discharge_announcement, foreign_key: true
      t.references :targeted_municipality, foreign_key: true

      t.timestamps null: false
    end
    add_index :discharge_announcement_targeted_municipalities, :discharge_announcement_id, name:'idx_discharge_announcement_targeted_municipalities_01'
    add_index :discharge_announcement_targeted_municipalities, :targeted_municipality_id, name:'idx_discharge_announcement_targeted_municipalities_02'
  end
end
