require 'rubygems'
require 'anemone'
require 'cgi'

crawl_db = Settings.crawl_db

namespace :notice_discharge do
  desc 'ダム放流通知から放流情報を取得'
  # bundle exec rake notice_discharge:check

  task check: :environment do
    StackProf.run(mode: :cpu, out: 'tmp/notice_discharge-check.dump') do
      opts = {
        user_agent:  'AnemoneCrawler/0.00',
        delay:       1,
        depth_limit: 0,
        storage:  Anemone::Storage.SQLite3(crawl_db)
      }

      notice_discharge = nil
      notice_discharge_areas = []

      store = Anemone::Storage.SQLite3(crawl_db)
      store.delete(Uri::RiverDisasterPreventionInfo::DISCHARGE_TOP_URI)

      # ダム放流通知全国地図 のトップページ
      Anemone.crawl(Uri::RiverDisasterPreventionInfo::DISCHARGE_TOP_URI, opts) do |anemone|
        # exit if anemone.pages.nil?
        anemone.on_every_page do |page|
          notice_discharge = Pddn::Top.new(page.doc)
        end
      end

      # (地方別)ダム放流通知発表状況表を取得
      # http:/川の防災情報URL?areaCode=81 〜 90
      notice_discharge.discharge_uris.each do |uri|
        store.delete("#{Uri::RiverDisasterPreventionInfo::TOP_URI}/#{uri}")
        Anemone.crawl("#{Uri::RiverDisasterPreventionInfo::TOP_URI}/#{uri}", opts) do |anemone|
          anemone.on_every_page do |page|
            area = Pddn::Area.new(page.doc)
            notice_discharge_areas << area

            # (地方別)ダム放流通知発表状況をデータベースに登録
            area.discharge_announcements.each do |announcement|
              DischargeAnnouncement.find_or_create_by(announcement.to_h)
            end
          end
        end
      end

      # discharge_reports_uris << "nrpc0603gDisp.do?damDischgCode=2183221872&reportTime=20150204090000&reportNo=1"
      notice_discharge_areas.each do |area|
        area.discharge_announcements.each do |announcement|
          announcement.discharge_notices.each do |notice|
            notice_path_query  = "#{notice.discharge_report_path}?#{notice.discharge_report_query}"
            key_url_for_notice = "#{Uri::RiverDisasterPreventionInfo::TOP_URI}/#{notice_path_query}"
            if !Rails.env.production? && store.key?(key_url_for_notice)
              # 本番環境以外の場合は、ストアデータがあればそれを使う
              store[key_url_for_notice].doc.xpath('//div[@class="alarm"]').each do |report|
                report_find_or_create(notice, report)
              end
            else
              Anemone.crawl(key_url_for_notice, opts) do |anemone|
                anemone.on_every_page do |page|
                  page.doc.xpath('//div[@class="alarm"]').each do |report|
                    report_find_or_create(notice, report)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  desc 'ダム放流通知のダムと国土数値情報のダムの関連づけ'
  # bundle exec rake notice_discharge:matching_dam
  task matching_dam: :environment do
    StackProf.run(mode: :cpu, out: 'tmp/notice_discharge-matching_dam.dump') do
      DischargeAnnouncement.all.each do |announcement|
        dam_name = announcement.dam_name.gsub('ダム', '').gsub(/(\(機構\)|（機構）|\(利水\)|（利水）)/, '')
        dam =
          Dam.find_by(name: dam_name) ||
          Dam.find_by(name: dam_name.tr('ケ', 'ヶ')) ||
          Dam.find_by(name: "#{dam_name}（再）")
        next unless dam

        dam_discharge_code =
          DamDischargeCode.find_or_initialize_by(
            dam_id:          dam.id,
            dam_cd:          dam.dam_cd,
            dam_dischg_code: announcement.dam_dischg_code
          )

        dam_discharge_code.dam_name = dam.name
        dam_discharge_code.save!
      end
    end
  end

  private

  # ダム放流通知文をデータベースに登録
  def report_find_or_create(notice, report)
    notice_report = Pddn::Report.new(report)
    DischargeAnnouncement
      .find_by(dam_dischg_code: notice.dam_dischg_code)
      .discharge_reports.find_or_create_by(
        notice.to_h.merge(notice_report.to_h)
          .reject { |k, _| DischargeReport.attribute_names.exclude?(k.to_s) }
      )
  end
end
