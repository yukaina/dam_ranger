require 'rails_helper'

RSpec.describe Dam, type: :model do
  describe 'check validates.' do
    subject { dam.errors }

    describe '.presence' do
      before { dam.valid? }

      context 'when without a latitude.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, latitude: nil) }

        it { expect(subject[:latitude]).to include("can't be blank") }
      end

      context 'when without a longitude.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, longitude: nil) }

        it { expect(subject[:longitude]).to include("can't be blank") }
      end

      context 'when without a name.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, name: nil) }

        it { expect(subject[:name]).to include("can't be blank") }
      end

      context 'when without a height.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, height: nil) }

        it { expect(subject[:height]).to include("can't be blank") }
      end

      context 'when without a width.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, width: nil) }

        it { expect(subject[:width]).to include("can't be blank") }
      end

      context 'when without a volume.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, volume: nil) }

        it { expect(subject[:volume]).to include("can't be blank") }
      end

      context 'when without a pondage.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, pondage: nil) }

        it { expect(subject[:pondage]).to include("can't be blank") }
      end

      context 'when without a institution_cd.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, institution_cd: nil) }

        it { expect(subject[:institution_cd]).to include("can't be blank") }
      end

      context 'when without a completed_on.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, completed_on: nil) }

        it { expect(subject[:completed_on]).to include("can't be blank") }
      end

      context 'when without a location_accuracy_cd.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam, location_accuracy_cd: nil) }

        it { expect(subject[:location_accuracy_cd]).to include("can't be blank") }
      end
    end

    describe '.uniqueness' do
      before do
        FactoryGirl.create(:daisetsu_dam)
        dam.valid?
      end

      context 'when without a location_accuracy_cd.' do
        let(:dam) { FactoryGirl.build(:daisetsu_dam) }

        it { expect(subject[:dam_cd]).to include('has already been taken') }
      end
    end
  end
end
