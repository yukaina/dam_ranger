class CreateTargetedMunicipalities < ActiveRecord::Migration
  def change
    create_table :targeted_municipalities do |t|
      t.text :name

      t.timestamps null: false
    end
    add_index :targeted_municipalities, :name, unique: true, name:'uidx_targeted_municipalities_01'
  end
end
