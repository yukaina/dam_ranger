crawl_db = Settings.crawl_db

namespace :dam_quantity_period do

  desc 'ダム諸量の存在する年を取得'
  # bundle exec rake dam_quantity_period:year

  task year: :environment do
    Rails.logger.debug '-' * 80
    opts = {
        user_agent:  "AnemoneCrawler/0.00",
        delay:       1,
        depth_limit: 1,
        storage:  Anemone::Storage.SQLite3(crawl_db)
    }
    store = Anemone::Storage.SQLite3(crawl_db)

    dam_quantities = DamQuantity.where.not(observatory_sign_cd: nil)
    dam_quantities.each do |dam_quantity|
      Anemone.crawl("#{Uri::RiverDisasterPreventionInfo::SEARCH_DAM_DATA_URI}?ID=#{dam_quantity.observatory_sign_cd}", opts) do |anemone|
        anemone.on_every_page do |page|
          quantity_years = Pdql::ExistingYear.new(page.doc)
          ActiveRecord::Base.transaction do
            quantity_years.exist_years.each do |year|
              DamQuantityRecordYear.find_or_create_by(dam_quantity: dam_quantity, observatory_sign_cd: dam_quantity.observatory_sign_cd, year: year)
            end
          end
        end
      end
      store.delete("#{Uri::RiverDisasterPreventionInfo::SEARCH_DAM_DATA_URI}?ID=#{dam_quantity.observatory_sign_cd}")
    end
  end
end
