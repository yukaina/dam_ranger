class CreateDamQuantityRecords < ActiveRecord::Migration
  def change
    create_table :dam_quantity_records do |t|
      t.references :dam_quantity, index: true, foreign_key: true
      t.string :observatory_sign_cd
      t.datetime :observatory_at
      t.date :observatory_on
      t.time :observatory_time
      t.float :basin_avg_precipitation
      t.integer :pondage
      t.float :inflow_quantity
      t.float :discharge_quantity
      t.float :storing_water_rate

      t.timestamps null: false
    end
  end
end
