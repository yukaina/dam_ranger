crawl_db = Settings.crawl_db

namespace :dam_quantity do

  desc 'ダム諸量取得'
  # bundle exec rake dam_quantity:quantity

  # http://example.com/cgi-bin/DspDamData.exe?KIND=1&ID=605091285502400&BGNDATE=20130101&ENDDATE=20130131&KAWABOU=NO
  task quantity: :environment do
    opts = {
        user_agent:  'AnemoneCrawler/0.00',
        delay:       1,
        depth_limit: 1,
        storage:  Anemone::Storage.SQLite3(crawl_db)
    }
    store = Anemone::Storage.SQLite3(crawl_db)

    dqr = DamQuantityRecord.last

    dam_quantities = if dqr
        DamQuantity.where.not(observatory_sign_cd: nil).where(DamQuantity.arel_table[:id].gt(dqr.dam_quantity_id))
      else
        DamQuantity.where.not(observatory_sign_cd: nil)
      end

    dam_quantities.each do |dam_quantity|
      dam_quantity.dam_quantity_record_years.map(&:year).each do |year|
        break if Date.today.year < year
        (1..12).each do |month|
          start_day = Date::new(year, month, 1)
          break if Date.today < start_day
          end_day = start_day.end_of_month
          begin
            Anemone.crawl("#{Uri::RiverDisasterPreventionInfo::PERIOD_DAM_DATA_URI}?KIND=1&ID=#{dam_quantity.observatory_sign_cd}&BGNDATE=#{start_day.strftime('%Y%m%d')}&ENDDATE=#{end_day.strftime('%Y%m%d')}&KAWABOU=NO", opts) do |anemone|
              anemone.on_pages_like(/\.dat\z/) do |page|
                search_result = Pdql::SearchResult.new(page.body)
                search_result.dam_quantities.each do |dam|
                  begin
                  DamQuantityRecord.create!(
                    dam.to_h.merge(
                      dam_quantity_id: dam_quantity.id,
                      observatory_sign_cd: dam_quantity.observatory_sign_cd
                    )
                  )
                  rescue => e
                    puts e.message
                  end
                end
              end
            end
          ensure
            store.delete("#{Uri::RiverDisasterPreventionInfo::PERIOD_DAM_DATA_URI}?KIND=1&ID=#{dam_quantity.observatory_sign_cd}&BGNDATE=#{start_day.strftime('%Y%m%d')}&ENDDATE=#{end_day.strftime('%Y%m%d')}&KAWABOU=NO")
          end
        end
      end
    end
  end
end
