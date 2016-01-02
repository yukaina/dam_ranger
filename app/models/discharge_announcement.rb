# ダム放流通知発表状況表(〇〇地方)のtableのtr(ダム毎の放流通知の行)
# noticeは、第N号で複数ある「ダム放流通知文」へのリンク
class DischargeAnnouncement < ActiveRecord::Base
  has_many :discharge_reports
  has_many :discharge_announcement_targeted_municipalities
  has_many :targeted_municipalities, through: :discharge_announcement_targeted_municipalities

  attr_reader :municipalities
  after_create :crate_targeted_municipalities

  validates :dam_dischg_code, uniqueness: { scope: [:dam_name, :river_system_name, :river_name, :target_municipality] }

  def target_municipality=(val)
    self[:target_municipality] = val
    targeted_municipality(val) # 対象市区町村を、個別に登録
  end

  private

  def targeted_municipality(val)
    @municipalities = val.split('、')
  end

  def crate_targeted_municipalities
    municipalities.each do |municipality|
      targeted_municipality = TargetedMunicipality.find_by(name: municipality)
      if targeted_municipality
        discharge_announcement_targeted_municipalities.create!(targeted_municipality: targeted_municipality)
      else
        targeted_municipalities.create!(name: municipality)
      end
    end
  end
end
