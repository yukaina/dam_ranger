require 'rails_helper'
require 'rake'

describe 'association_notice_discharge:matching_dam' do
  include_context 'rake'
  let(:task_name) { 'association_notice_discharge:dams' }

  before do
    FactoryGirl.create(:discharge_announcement_with_one_target_municipality)
    FactoryGirl.create(:discharge_announcement_with_two_target_municipality)
    FactoryGirl.create(:discharge_announcement_with_four_target_municipality)
    FactoryGirl.create(:discharge_announcement_with_ten_target_municipality)
    FactoryGirl.create(:discharge_announcement_with_kikou)
    FactoryGirl.create(:discharge_announcement_with_risui)

    FactoryGirl.create(:daisetsu_dam)
    FactoryGirl.create(:kanayama_dam)
    FactoryGirl.create(:shichikashuku_dam)
    FactoryGirl.create(:miwa_dam)
    FactoryGirl.create(:sameura_dam)
    FactoryGirl.create(:sarutani_dam)
  end

  it 'dams' do
    subject.invoke
    expect(DamDischargeCode.count).to eq(6)
  end
end
