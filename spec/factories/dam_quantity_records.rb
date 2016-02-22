FactoryGirl.define do
  factory :dam_quantity_record do
    dam_quantity nil
    observatory_sign_cd "MyString"
    observatory_at "2016-02-20 20:32:30"
    observatory_on "2016-02-20"
    observatory_time "2016-02-20 20:32:30"
    basin_avg_precipitation 1.5
    pondage 1
    inflow_quantity 1.5
    discharge_quantity 1.5
    storing_water_rate 1.5
  end
end
