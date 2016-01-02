# ダム放流通知発表状況表(○○地方)の各ダムにある対象市区町村を「、」区切りで分割
class TargetedMunicipality < ActiveRecord::Base
  has_many :discharge_announcement_targeted_municipalities
  has_many :discharge_announcements, through: :discharge_announcement_targeted_municipalities
  validates :name, presence: true
  validates :name, uniqueness: true
end
