require 'rails_helper'

RSpec.describe DischargeAnnouncement, type: :model do
  describe '#target_municipality' do
    subject { discharge_announcement }

    context 'when target_municipality is one.' do
      let(:discharge_announcement) { FactoryGirl.build(:discharge_announcement_with_one_target_municipality) }

      it { expect(subject.target_municipality).to eq('上川郡上川町') }
      it { expect(subject.municipalities).to eq(%w(上川郡上川町)) }
    end

    context 'when target_municipality is four.' do
      let(:discharge_announcement) { FactoryGirl.build(:discharge_announcement_with_four_target_municipality) }

      it { expect(subject.target_municipality).to eq('白石市、刈田郡蔵王町、柴田郡大河原町、柴田郡柴田町') }
      it { expect(subject.municipalities).to eq(%w(白石市 刈田郡蔵王町 柴田郡大河原町 柴田郡柴田町)) }
    end
  end
end
