class CreateDamDischargeCodes < ActiveRecord::Migration
  def change
    create_table :dam_discharge_codes do |t|
      t.references :dam, index: true, foreign_key: true
      t.integer :dam_cd
      t.text :dam_dischg_code
      t.text :dam_name

      t.timestamps null: false
    end
    add_index :dam_discharge_codes, :dam_dischg_code
  end
end
