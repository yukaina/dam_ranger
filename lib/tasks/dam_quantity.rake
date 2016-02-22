crawl_db = Settings.crawl_db

namespace :dam_quantity do
  desc 'ダム諸量一覧表からダムを取得してdam_quantitiesにデータ登録'
  # bundle exec rake dam_quantity:check

  task check: :environment do
    opts = {
        user_agent:  'AnemoneCrawler/0.00',
        delay:       1,
        depth_limit: 1,
        storage:  Anemone::Storage.SQLite3(crawl_db)
    }
    store = Anemone::Storage.SQLite3(crawl_db)
    begin
      Anemone.crawl(Uri::RiverDisasterPreventionInfo::QUANTITY_URI, opts) do |anemone|
        # クロールするごとに呼び出される
        anemone.focus_crawl do |page|
          # 条件に一致するリンクだけ残す(ダム地方)
          # この `links` はanemoneが次にクロールする候補リスト
          page.links.keep_if { |link|
            link.to_s.match(Uri::RiverDisasterPreventionInfo::REGEX_QUANTITY_AREA_PATH)
          }

          # crawl_dbに該当するURLが存在している場合は削除(スキップしないようにする)
          page.links.each do |link|
            store.delete(link.to_s)
          end
        end

        anemone.on_every_page do |page|
          # ダム地方の一覧ページは飛ばす(=Anemone.crawlで指定したURL。anemone.focus_crawlで絞ってもAnemone.crawlで指定したURLはon_every_pageの対象となっている)
          next if page.url.to_s == Uri::RiverDisasterPreventionInfo::QUANTITY_URI
          area = Pdql::Area.new(page.doc, page.url.to_s)

          area.dams.each do |dam|
            dam_params = {
              name:               dam.name,
              dam_admin_type:     dam.admin_type,
              regional_bureau_cd: dam.area_cd
            }.tap { |p| p.merge!(observatory_sign_cd: dam.observatory_sign_cd) if dam.history_link? }
            DamQuantity.create(dam_params)
          end
        end
      end
    ensure
      store.delete(Uri::RiverDisasterPreventionInfo::QUANTITY_URI)
    end
  end

  desc 'ダム諸量の存在する年を取得'
  # bundle exec rake dam_quantity:year

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
