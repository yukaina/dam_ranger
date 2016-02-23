require 'uri'
module Uri
  # 川の防災情報用のURI定数
  class RiverDisasterPreventionInfo
    HTTP_SCHEME = Rails.application.secrets.scheme.freeze
    DOMAIN = Rails.application.secrets.domain.freeze
    TOP_URI = "#{HTTP_SCHEME}://#{Rails.application.secrets.quantity_host}.#{DOMAIN}".freeze

    # 諸量
    QUANTITY_HISTORY_URI = "#{HTTP_SCHEME}://#{Rails.application.secrets.quantity_history_host}.#{DOMAIN}".freeze

    QUANTITY_URI = "#{TOP_URI}/#{Rails.application.secrets.quantity_top_path}".freeze
    QUANTITY_AREA_PATH = Rails.application.secrets.quantity_area_top_path.to_s.freeze
    QUANTITY_AREA_URI = "#{TOP_URI}/#{Rails.application.secrets.quantity_area_top_path}".freeze
    REGEX_QUANTITY_AREA_PATH = /#{QUANTITY_AREA_PATH}/
    QUANTITY_HISTORY_TOP_URI = "#{QUANTITY_HISTORY_URI}/#{Rails.application.secrets.quantity_top_path}".freeze

    SEARCH_DAM_DATA_URI = "#{QUANTITY_HISTORY_URI}/cgi-bin/SrchDamData.exe".freeze
    PERIOD_DAM_DATA_URI = "#{QUANTITY_HISTORY_URI}/cgi-bin/DspDamData.exe".freeze

    # 放流通知
    DISCHARGE_TOP_URI = "#{TOP_URI}/#{Rails.application.secrets.discharge_top_path}".freeze
    DISCHARGE_AREA_URI = "#{TOP_URI}/#{Rails.application.secrets.discharge_area_path}".freeze
    DISCHARGE_NOTICE_URI = "#{TOP_URI}/#{Rails.application.secrets.discharge_notice_path}".freeze
  end
end
