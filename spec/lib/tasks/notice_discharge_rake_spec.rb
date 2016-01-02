require 'rails_helper'
require 'rake'

describe 'notice_discharge:check' do
  include_context 'rake'
  let(:task_name) { 'notice_discharge:check' }

  before(:each) do
    VCR.use_cassette 'lib/tasks/notice_discharge/check' do
      subject.invoke
    end
  end

  it { expect(DischargeReport.count).to eq(71) }
  it { expect(DischargeReport.first.dam_dischg_code).to eq('2329723309') }
  it { expect(DischargeReport.last.dam_dischg_code).to eq('2281522899') }
  it { expect(DischargeReport.first.dam_name).to eq('大雪ダム') }
  it { expect(DischargeReport.first.discharge_announcement).to eq(DischargeReport.first.discharge_announcement) }
  it { expect(DischargeReport.last.dam_name).to eq('下筌ダム') }
  it { expect(DischargeReport.first.discharge_announcement.target_municipality).to eq('上川郡上川町') }
  it { expect(DischargeReport.last.discharge_announcement.target_municipality).to eq('阿蘇郡小国町、日田市') }
end

describe 'notice_discharge:matching_dam' do
  include_context 'rake'
  let(:task_name) { 'notice_discharge:matching_dam' }

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
    subject.invoke
  end

  it 'matching_dam' do
    expect(DamDischargeCode.count).to eq(6)
  end
end
