namespace :dam_data do
  desc '国土数値情報のダムデータ(環境変数FILE_PATHで指定したxmlファイル)をimport'

  # bundle exec rake dam_data:import FILE_PATH='W01-05.xml'

  task import: :environment do
    COMPLETED_YEAR_XPATH = 'jps:TM_Instant.position/jps:TM_Position.anyOther/jps:TM_CalDate/TM_CalDate.calDate'.freeze
    FRAMES_XPATH = 'jps:TM_Instant.position/jps:TM_Position.anyOther/jps:TM_CalDate/TM_TemporalPosition.frame'.freeze
    GM_POINT_XPATH = 'jps:GM_Point.position/jps:DirectPosition/DirectPosition.coordinate'.freeze

    file_path = ENV['FILE_PATH']
    logger = Logger.new('log/dam_data_import.log')
    logger.info "No File #{file_path}" unless File.exist?(file_path)

    xml_doc = Nokogiri::XML(File.open(file_path, &:read))
    dams_xml = xml_doc.xpath('ksj:GI/dataset/ksj:object/ksj:AA01/ksj:OBJ/ksj:GA01')

    dams_xml.each do |dam_xml|
      pos_id = dam_xml.xpath('ksj:POS').first.attributes['idref']
      gm_point = xml_doc.xpath("ksj:GI/dataset/ksj:object/ksj:AA01/ksj:OBJ/jps:GM_Point[@id='#{pos_id}']")

      # completed date
      yc3 = dam_xml.xpath('ksj:YC3').first.attributes['idref']
      completed_year_entity = xml_doc.xpath("ksj:GI/dataset/ksj:object/ksj:AA01/ksj:OBJ/jps:TM_Instant[@id='#{yc3}']")
      completed_year = completed_year_entity.xpath(COMPLETED_YEAR_XPATH)

      # TimeZone
      frame = completed_year_entity.xpath(FRAMES_XPATH).first.attributes['idref']
      trs = xml_doc.xpath("ksj:GI/dataset/ksj:object/ksj:AA01/ksj:OBJ/jps:RS_CRS[@id='#{frame}']")
      time_zone = trs.xpath('jps:RS_ReferenceSystem.name/jps:RS_Identifier/jps:RS_Identifier.code')

      latitude, longitude = gm_point.xpath(GM_POINT_XPATH).text.split(' ')
      dimension =  gm_point.xpath('jps:GM_Point.position/jps:DirectPosition/DirectPosition.dimension').text

      ActiveRecord::Base.transaction do
        begin
          dam = Dam.create!(
            latitude:             latitude,
            longitude:            longitude,
            dimension:            dimension,
            name:                 dam_xml.xpath('ksj:DAN').text,
            dam_cd:               dam_xml.xpath('ksj:DMC').text,
            river_system_name:    dam_xml.xpath('ksj:NWS').text,
            river_name:           dam_xml.xpath('ksj:NOR').text,
            height:               dam_xml.xpath('ksj:DBH').text,
            width:                dam_xml.xpath('ksj:DBS').text,
            volume:               dam_xml.xpath('ksj:BAV').text,
            pondage:              dam_xml.xpath('ksj:TOP').text,
            institution_cd:       dam_xml.xpath('ksj:IIC').text,
            completed_on:         Date.parse("#{completed_year.text.tr(' ', '/')} #{time_zone.text}"),
            address:              dam_xml.xpath('ksj:AS4').text,
            location_accuracy_cd: dam_xml.xpath('ksj:LAC').text
          )

          dam_xml.xpath('ksj:TOD').each do |tod|
            DamType.create!(dam: dam, type_cd: tod.text)
          end

          dam_xml.xpath('ksj:POD').each do |pod|
            DamPurpose.create!(dam: dam, purpose_cd: pod.text)
          end
        rescue ActiveRecord::RecordInvalid => e
          # puts "#{dam_xml.xpath('ksj:DMC').text}: #{e.message}"
          logger.info "#{dam_xml.xpath('ksj:DMC').text}: #{e.message}"
          next
        end
      end
    end
  end
end
