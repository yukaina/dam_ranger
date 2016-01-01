FactoryGirl.define do
  factory :dam do
    trait :daisetsu do
      latitude 43.6767419303151
      longitude 143.036193373144
      dimension 2
      name '大雪'
      dam_cd 89
      river_system_name '石狩川'
      river_name '石狩川'
      height 86.5
      width 440
      volume 3875
      pondage 66_000
      institution_cd 1
      completed_on '1975-04-01'
      address '北海道上川郡上川町字層雲峡大学平'
      location_accuracy_cd 1
    end

    trait :kanayama do
      latitude 43.1295666615534
      longitude 142.442634508162
      dimension 2
      name '金山'
      dam_cd 125
      river_system_name '石狩川'
      river_name '空知川'
      height 57.3
      width 288.5
      volume 220
      pondage 150_450
      institution_cd 1
      completed_on '1967-04-01'
      address '北海道空知郡南富良野町字金山'
      location_accuracy_cd 1
    end

    # 'ヶ'
    trait :shichikashuku do
      latitude 37.9613754330449
      longitude 140.512949630059
      dimension 2
      name '七ヶ宿'
      dam_cd 320
      river_system_name '阿武隈川'
      river_name '白石川'
      height 90
      width 565
      volume 5201
      pondage 109_000
      institution_cd 1
      completed_on '1991-04-01'
      address '宮城県刈田郡七ヶ宿町字切通'
      location_accuracy_cd 1
    end

    # (再)
    trait :miwa do
      latitude 35.8138033072292
      longitude 138.079262880395
      dimension 2
      name '美和（再）'
      dam_cd 821
      river_system_name '天竜川'
      river_name '三峰川'
      height 69.1
      width 367.5
      volume 286
      pondage 34_300
      institution_cd 1
      completed_on '9999-04-01'
      address '長野県上伊那郡高遠町大字勝間'
      location_accuracy_cd 1
    end

    # (機構)
    trait :sameura do
      latitude 33.75652778
      longitude 133.5504167
      dimension 2
      name '早明浦'
      dam_cd 2201
      river_system_name '吉野川'
      river_name '吉野川'
      height 106
      width 400
      volume 1200
      pondage 316_000
      institution_cd 6
      completed_on '1977-04-01'
      address '高知県長岡郡本山町吉野'
      location_accuracy_cd 1
    end

    # (利水)
    trait :sarutani do
      latitude 34.179367873802
      longitude 135.741328154834
      dimension 2
      name '猿谷'
      dam_cd 1375
      river_system_name '新宮川'
      river_name '十津川'
      height 74
      width 170
      volume 174
      pondage 23_300
      institution_cd 1
      completed_on '1957-04-01'
      address '奈良県吉野郡大塔村大字辻堂大和田'
      location_accuracy_cd 1
    end

    factory :daisetsu_dam,      traits: [:daisetsu]
    factory :kanayama_dam,      traits: [:kanayama]
    factory :shichikashuku_dam, traits: [:shichikashuku]
    factory :miwa_dam,          traits: [:miwa]
    factory :sameura_dam,       traits: [:sameura]
    factory :sarutani_dam,      traits: [:sarutani]
  end
end
