# 国土数値情報のダムデータ(W01-05.xml)を格納用
class Dam < ActiveRecord::Base
  has_many :dam_types
  has_many :dam_purposes

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :name, presence: true
  validates :dam_cd, uniqueness: true
  validates :height, presence: true
  validates :width, presence: true
  validates :volume, presence: true
  validates :pondage, presence: true
  validates :institution_cd, presence: true
  validates :completed_on, presence: true
  validates :location_accuracy_cd, presence: true
end

# institution_cd
#   1: 国土交通省
#   2: 沖縄開発庁
#   3: 農林水産省
#   4: 都道府県
#   5: 市区町村
#   6: 水資源開発公団
#   7: その他の公共企業体
#   8: 土地改良区
#   9: 利水組合・用水組合
#  10: 電力会社・電源開発株式会社
#  11: その他の企業
#  12: 個人
#  13: その他
#
# location_accuracy_cd
#   1: レベル１(位置精度最高)
#   2: レベル２(位置精度高)
#   3: レベル３(位置精度中)
#   4: レベル４(位置精度低)
