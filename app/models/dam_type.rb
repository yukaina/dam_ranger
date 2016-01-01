# ダムの形式
class DamType < ActiveRecord::Base
  belongs_to :dam
end

#    1: アーチダム
#    2: バットレスダム
#    3: アースダム
#    4: アスファルトフェイシングダム
#    5: アスファルトコアダム
#    6: フローティングゲートダム(可動堰)
#    7: 重力式コンクリートダム
#    8: 重力式アーチダム
#    9: 重力式コンクリートダム・フィルダム複合ダム
#   10: 中空重力式コンクリートダム
#   11: マルティプルアーチダム
#   12: ロックフィルダム
#   13: 台形 CSG ダム
