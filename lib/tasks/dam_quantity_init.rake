crawl_db = Settings.crawl_db

namespace :dam_quantity_init do
  desc 'ダム諸量一覧表からダムを取得してdam_quantitiesにデータ登録'
  # bundle exec rake dam_quantity_init:setting

  task setting: :environment do
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
end
