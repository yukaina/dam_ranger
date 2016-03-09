require 'rails_helper'
require 'rake'

describe 'notice_discharge:crawling' do
  include_context 'rake'
  let(:task_name) { 'notice_discharge:crawling' }

  def rake_invoke
    VCR.use_cassette 'lib/tasks/notice_discharge/check' do
      subject.invoke
    end
  end

  it { expect { rake_invoke }.to change { DischargeReport.count }.to(71) }

  describe '詳細の値確認' do
    before do
      rake_invoke
    end

    it { expect(DischargeReport.first.dam_dischg_code).to eq('2329723309') }
    it { expect(DischargeReport.last.dam_dischg_code).to eq('2281522899') }
    it { expect(DischargeReport.first.dam_name).to eq('大雪ダム') }
    it { expect(DischargeReport.first.discharge_announcement).to eq(DischargeReport.first.discharge_announcement) }
    it { expect(DischargeReport.last.dam_name).to eq('下筌ダム') }
    it { expect(DischargeReport.first.discharge_announcement.target_municipality).to eq('上川郡上川町') }
    it { expect(DischargeReport.last.discharge_announcement.target_municipality).to eq('阿蘇郡小国町、日田市') }
  end
end
