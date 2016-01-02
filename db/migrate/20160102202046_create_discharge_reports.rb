class CreateDischargeReports < ActiveRecord::Migration
  def change
    create_table :discharge_reports do |t|
      t.text :dam_dischg_code
      t.datetime :report_at
      t.integer :report_no
      t.references :discharge_announcement, index: true, foreign_key: true
      t.text :dam_name
      t.text :rever_system_name
      t.text :rever_name
      t.text :report_article
      t.text :publisher
      t.text :title
      t.text :document

      t.timestamps null: false
    end
    add_index :discharge_reports, :dam_dischg_code
    add_foreign_key :discharge_reports, :discharge_announcements
  end
end
