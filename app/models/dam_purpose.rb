# ダムの用途
class DamPurpose < ActiveRecord::Base
  belongs_to :dam
end

# purpose_cd
# 1: 洪水調節、農地防災
# 2: 不特定用水、河川維持用水
# 3: 灌漑、特定（新規）灌漑用水
# 4: 上水道用水
# 5: 工業用水道用水
# 6: 発電
# 7: 消流雪用水
# 8: レクリエーション
