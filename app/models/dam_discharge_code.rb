# 国土数値情報のダム(dams)とダム放流通知(dischaerge_announcement)との関連づけ'
class DamDischargeCode < ActiveRecord::Base
  belongs_to :dam
  validates :dam_id, uniqueness: { scope: [:dam_cd, :dam_dischg_code] }
end
