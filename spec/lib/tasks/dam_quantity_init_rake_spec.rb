require 'rails_helper'
require 'rake'

describe 'dam_quantity_init' do
  describe 'dam_quantity_init:setting' do
    include_context 'rake' do
      let(:task_name) { 'dam_quantity_init:setting' }
    end

    def rake_invoke
      VCR.use_cassette 'lib/tasks/dam_quantity/check' do
        subject.invoke
      end
    end

    context 'when dam has observatory_sign_cd.' do
      it { expect { rake_invoke }.to change { DamQuantity.count }.to(469) }
    end
  end
end
