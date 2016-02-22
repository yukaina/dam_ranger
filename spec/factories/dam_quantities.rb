FactoryGirl.define do
  factory :dam_quantity do

    trait :tokachi do
      observatory_sign_cd "1368010829060"
      name "十勝ダム"
      dam_admin_type "国河川"
      observatory_classification_cd "80"
      river_system_cd "0108"
      jurisdiction_cd "01"
      sub_jurisdiction_cd "36"
      regional_bureau_cd "81"
      office_cd "029"
      observatory_id 60
      local_governments_cd nil
    end

    trait :yubari do
      observatory_sign_cd nil
      name "夕張シューパロダム"
      dam_admin_type "国河川"
      observatory_classification_cd nil
      river_system_cd nil
      jurisdiction_cd nil
      sub_jurisdiction_cd nil
      regional_bureau_cd "81"
      office_cd nil
      observatory_id nil
      local_governments_cd nil
    end

    factory :dam_quantity_with_tokachi, traits: [:tokachi]
    factory :dam_quantity_with_yubari,  traits: [:yubari]
  end
end
