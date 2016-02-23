# for 国土交通省【川の防災情報】ダム放流通知文
# (http://example.com/nrpc0603gDisp.do?damDischgCode=XXXXXXXXXX&reportTime=YYYYMMDDhhmmss&reportNo=N)
class DischargeReport < ActiveRecord::Base
  belongs_to :discharge_announcement

  validates :dam_dischg_code, uniqueness: { scope: [:report_at, :report_no] }

  def report_time=(val)
    self[:report_at] = Time.zone.parse(val)
  end

  def report_time
    report_at.strftime('%Y%m%d%H%M%S')
  end
end
