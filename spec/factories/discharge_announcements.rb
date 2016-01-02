FactoryGirl.define do
  factory :discharge_announcement do
    trait :one_municipality do
      dam_dischg_code '2329723309'
      dam_name '大雪ダム'
      river_system_name '石狩川'
      river_name '石狩川'
      target_municipality '上川郡上川町'
    end

    trait :two_municipality do
      dam_dischg_code '2329723309'
      dam_name '金山ダム'
      river_system_name '石狩川'
      river_name '空知川'
      target_municipality '富良野市、空知郡南富良野町'
    end

    trait :four_municipality do
      dam_dischg_code '2103921039'
      dam_name '七ケ宿ダム'
      river_system_name '阿武隈川'
      river_name '白石川'
      target_municipality '白石市、刈田郡蔵王町、柴田郡大河原町、柴田郡柴田町'
    end

    trait :ten_municipality do
      dam_dischg_code '2183221873'
      dam_name '美和ダム'
      river_system_name '天竜川'
      river_name '三峰川'
      target_municipality '飯田市、伊那市、駒ヶ根市、上伊那郡飯島町、上伊那郡中川村、上伊那郡宮田村、下伊那郡松川町、下伊那郡高森町、下伊那郡喬木村、下伊那郡豊丘村'
    end

    # （機構）
    trait :kikou do
      dam_dischg_code '1997019973'
      dam_name '早明浦ダム（機構）'
      river_system_name '吉野川'
      river_name '吉野川'
      target_municipality '三好市、長岡郡本山町、長岡郡大豊町、土佐郡土佐町'
    end

    # （利水）
    trait :risui do
      dam_dischg_code '1997019973'
      dam_name '猿谷ダム（利水）'
      river_system_name '新宮川'
      river_name '熊野川'
      target_municipality '五條市、吉野郡十津川村'
    end

    factory :discharge_announcement_with_one_target_municipality,    traits: [:one_municipality]
    factory :discharge_announcement_with_two_target_municipality,    traits: [:two_municipality]
    factory :discharge_announcement_with_four_target_municipality,   traits: [:four_municipality]
    factory :discharge_announcement_with_ten_target_municipality,    traits: [:ten_municipality]
    factory :discharge_announcement_with_kikou,                      traits: [:kikou]
    factory :discharge_announcement_with_risui,                      traits: [:risui]
  end
end
