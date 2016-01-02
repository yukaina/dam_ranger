# ダム放流通知発表状況表(○○地方)の各ダムと対象市区町村との中間テーブル
class DischargeAnnouncementTargetedMunicipality < ActiveRecord::Base
  belongs_to :discharge_announcement
  belongs_to :targeted_municipality

  validates :discharge_announcement_id, uniqueness: { scope: [:targeted_municipality_id] }
end
