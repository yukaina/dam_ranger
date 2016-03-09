require 'rubygems'
require 'anemone'
require 'cgi'

namespace :association_notice_discharge do

  desc 'ダム放流通知のダムと国土数値情報のダムの関連づけ'
  # bundle exec rake association_notice_discharge:dams
  task dams: :environment do
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
end
