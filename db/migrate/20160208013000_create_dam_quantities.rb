class CreateDamQuantities < ActiveRecord::Migration
  def change
    create_table :dam_quantities do |t|
      t.string :observatory_sign_cd
      t.string :name
      t.string :dam_admin_type
      t.string :observatory_classification_cd
      t.string :river_system_cd
      t.string :jurisdiction_cd
      t.string :sub_jurisdiction_cd
      t.string :regional_bureau_cd
      t.string :office_cd
      t.integer :observatory_id
      t.string :local_governments_cd

      t.timestamps null: false
    end
  end
end
