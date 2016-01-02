require 'rails_helper'

RSpec.describe DischargeAnnouncement, type: :model do
  describe 'validates' do
    before do
      FactoryGirl.create(:discharge_announcement_with_one_target_municipality)
      discharge_announcement.valid?
    end

    context 'when within scope.' do
      let(:discharge_announcement) { FactoryGirl.build(:discharge_announcement_with_one_target_municipality) }

      subject { discharge_announcement.errors }

      it { expect(subject[:dam_dischg_code]).to include('has already been taken') }
    end

    context 'when without scope.' do
      context 'when dam_name dont duplicated.' do
        let(:discharge_announcement) do
          FactoryGirl.build(:discharge_announcement_with_one_target_municipality, dam_name: 'NOT大雪ダム')
        end

        subject { discharge_announcement }

        it { expect(subject.errors[:dam_dischg_code]).to be_blank }
        it { expect(subject.valid?).to be_truthy }
      end

      context 'when dam_name dont duplicated.' do
        let(:discharge_announcement) do
          FactoryGirl.build(:discharge_announcement_with_one_target_municipality, river_system_name: 'NOT石狩川')
        end

        subject { discharge_announcement }

        it { expect(subject.errors[:dam_dischg_code]).to be_blank }
        it { expect(subject.valid?).to be_truthy }
      end

      context 'when dam_name dont duplicated.' do
        let(:discharge_announcement) do
          FactoryGirl.build(:discharge_announcement_with_one_target_municipality, target_municipality: 'NOT上川郡上川町')
        end

        subject { discharge_announcement }

        it { expect(subject.errors[:dam_dischg_code]).to be_blank }
        it { expect(subject.valid?).to be_truthy }
      end
    end
  end

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

  describe 'after_create' do
    before do
      FactoryGirl.create(:discharge_announcement_with_four_target_municipality)
    end

    describe '#targeted_municipality' do
      subject { TargetedMunicipality.all }
      it { expect(subject.count).to eq(4) }
      it { expect(subject.map(&:name)).to match_array(%w(柴田郡柴田町 柴田郡大河原町 刈田郡蔵王町 白石市)) }
    end

    describe '#discharge_announcement_targeted_municipalities' do
      context 'when TargetedMunicipality.first' do
        subject { TargetedMunicipality.first.discharge_announcement_targeted_municipalities }

        it { expect(subject.first.discharge_announcement_id).to eq(TargetedMunicipality.first.id) }
        it { expect(subject.last.discharge_announcement_id).to eq(TargetedMunicipality.first.id) }
      end

      context 'when TargetedMunicipality.last' do
        subject { TargetedMunicipality.last.discharge_announcement_targeted_municipalities }

        it { expect(subject.first.discharge_announcement_id).to eq(TargetedMunicipality.first.id) }
        it { expect(subject.last.discharge_announcement_id).to eq(TargetedMunicipality.first.id) }
      end
    end
  end
end
