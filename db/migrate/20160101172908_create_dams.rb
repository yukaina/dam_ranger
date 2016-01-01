class CreateDams < ActiveRecord::Migration
  def change
    create_table :dams do |t|
      t.decimal :latitude,             null: false, precision: 18, scale: 15
      t.decimal :longitude,            null: false, precision: 18, scale: 15
      t.integer :dimension,            null: false, default: 2
      t.text    :name,                 null: false
      t.integer :dam_cd,               null: false
      t.text    :river_system_name
      t.text    :river_name
      t.decimal :height,               null: false, precision: 18, scale: 15
      t.decimal :width,                null: false, precision: 18, scale: 15
      t.integer :volume,               null: false
      t.integer :pondage,              null: false
      t.integer :institution_cd,       null: false
      t.date    :completed_on,         null: false
      t.text    :address,              null: false
      t.integer :location_accuracy_cd, null: false
    end
  end
end
