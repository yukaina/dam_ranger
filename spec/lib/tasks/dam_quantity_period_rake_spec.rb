require 'rails_helper'
require 'rake'

describe 'dam_quantity_period' do
  describe 'dam_quantity_period:year' do
    include_context 'rake' do
      let(:task_name) { 'dam_quantity_period:year' }
    end

    before(:each) do
      FactoryGirl.create(quantity)
    end

    def rake_invoke
      VCR.use_cassette 'lib/tasks/dam_quantity/year/tokachi'  do
        subject.invoke
      end
    end

    context 'when no observatory_sign_cd.' do
      let(:quantity) { :dam_quantity_with_yubari }

      it do
        rake_invoke
        expect(DamQuantityRecordYear.count).to eq(0)
      end
    end

    context 'when dam has observatory_sign_cd.' do
      let(:quantity) { :dam_quantity_with_tokachi }

      it { expect { rake_invoke }.to change { DamQuantityRecordYear.count }.from(0).to(14) }
    end
  end
end
