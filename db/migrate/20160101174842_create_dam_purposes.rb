class CreateDamPurposes < ActiveRecord::Migration
  def change
    create_table :dam_purposes do |t|
      t.integer :dam_id
      t.integer :purpose_cd

      t.timestamps null: false
    end
  end
end
