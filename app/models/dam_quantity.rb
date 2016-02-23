# ダム諸量データ用
class DamQuantity < ActiveRecord::Base
  has_many :dam_quantity_record_years
  validates :name, uniqueness: true
  before_create :set_parsed_observatory_sign, if: -> { observatory_sign_cd.present? }

  private

  def set_parsed_observatory_sign
    parsed_observatory_sign = parse_observatory_sign(observatory_sign_cd)
    parsed_observatory_sign.each do |k, v|
      self[k.to_sym] = v
    end
  end

  # rubocop:disable Style/MethodLength
  def parse_observatory_sign(obs_sign_cd)
    case observatory_sign_cd.size
    when 15
      {
        observatory_classification_cd: obs_sign_cd[0],
        river_system_cd:               obs_sign_cd[1..4],
        jurisdiction_cd:               obs_sign_cd[5..6],
        regional_bureau_cd:            obs_sign_cd[7..8],
        office_cd:                     obs_sign_cd[9..11],
        observatory_id:                obs_sign_cd[12..14],
        local_governments_cd:          obs_sign_cd[7..11]
      }
    when 13
      {
        jurisdiction_cd:               "0#{obs_sign_cd[0]}",
        sub_jurisdiction_cd:           obs_sign_cd[1..2],
        observatory_classification_cd: obs_sign_cd[3..4],
        river_system_cd:               "0#{obs_sign_cd[5..7]}",
        office_cd:                     "0#{obs_sign_cd[8..9]}",
        observatory_id:                obs_sign_cd[10..12]
      }
    end
  end
  # rubocop:enable Style/MethodLength
end

# 観測所分類コード:     observatory_classification_cd
# 水系コード:           river_system_cd
# 所管コード:           jurisdiction_cd
# 地方整備局等コード:   regional_bureau_cd
# 事務所コード:         office_cd
# 観測所番号:           observatory_id
# 地方公共団体等コード: local_governments_cd
#
# 所管毎の細分コード:   sub_jurisdiction_cd
#
# 605091285502400
# ① 6
# ② 0509
# ③ 12
# ④ 85
# ⑤ 502
# ⑥ 400
# ⑦ 85502

# １．15桁コードについてはトップページの「関連資料」から水文観測業務規程細則（pdf）第６条「観測所記号」（５ページ）を開くと解説がありますのでご活用ください。
# １	２	３	４	５	６	７	８	９	10	11	12	13	14	15
# ① 観測所分類コード：    1桁目
# ② 水系コード：          2,3,4,5桁目
# ③ 所管コード：          6,7桁目
# ④ 地方整備局等コード：  8,9桁目
# ⑤ 事務所コード：        10,11,12桁目
# ⑥ 観測所番号：          13,14,15桁目
# ⑦ 地方公共団体等コード：8,9,10,11,12桁目
#
#
# ２．13桁コードは15桁化（平成14年水文観測業務規程の改定）以前のコードですが、現在も一部の観測所は13桁コードのままで運用されています。
#
# ① 所管分類コード：    1桁目
# ② 所管毎の細分コード：2,3桁目
# ③ 観測所分類コード：  4,5桁目
# ④ 水系コード：        6,7,8桁目
# ⑤ 事務所コード：      9,10桁目
# ⑥ 観測所番号：        11,12,13桁目
