require 'rails_helper'

RSpec.describe DischargeReport, type: :model do
  describe '#report_time' do
    let(:discharge_report) { DischargeReport.new(report_at: Time.zone.local(2015, 01, 02, 03, 04, 05)) }

    subject { discharge_report }
    it { expect(subject.report_time).to eq '20150102030405' }
  end
end