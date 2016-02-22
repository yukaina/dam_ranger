class CreateDamQuantityRecordYears < ActiveRecord::Migration
  def change
    create_table :dam_quantity_record_years do |t|
      t.references :dam_quantity, index: true, foreign_key: true
      t.string :observatory_sign_cd
      t.integer :year

      t.timestamps null: false
    end
  end
end
