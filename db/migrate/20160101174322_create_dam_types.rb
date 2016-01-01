class CreateDamTypes < ActiveRecord::Migration
  def change
    create_table :dam_types, id: false do |t|
      t.references :dam
      t.column     :type_cd, :integer, null: false
    end
  end
end