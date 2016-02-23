require 'rails_helper'
require 'rake'

describe 'dam_quantity' do
  describe 'dam_quantity:check' do
    include_context 'rake' do
      let(:task_name) { 'dam_quantity:check' }
    end

    before(:each) do
      VCR.use_cassette 'lib/tasks/dam_quantity/check' do
        subject.invoke
      end
    end
    context 'when dam has observatory_sign_cd.' do
      it { expect(DamQuantity.count).to eq(469) }
    end
  end

  describe 'dam_quantity:year' do
    include_context 'rake' do
      let(:task_name) { 'dam_quantity:year' }
    end

    before(:each) do
      FactoryGirl.create(quantity)
      VCR.use_cassette 'lib/tasks/dam_quantity/year/tokachi' do
        subject.invoke
      end
    end

    context 'when no observatory_sign_cd.' do
      let(:quantity) { :dam_quantity_with_yubari }
      it { expect(DamQuantityRecordYear.count).to eq(0) }
    end

    context 'when dam has observatory_sign_cd.' do
      let(:quantity) { :dam_quantity_with_tokachi }
      it { expect(DamQuantityRecordYear.count).to eq(14) }
    end
  end

  describe 'dam_quantity:quantity' do
    include_context 'rake'
    let(:task_name) { 'dam_quantity:quantity' }
    let(:tokachi) { FactoryGirl.create(:dam_quantity_with_tokachi) }

    before(:each) do
      FactoryGirl.create(:dam_quantity_with_yubari)
      (2002..2004).each do |year|
        tokachi.dam_quantity_record_years.create!(observatory_sign_cd: tokachi.observatory_sign_cd, year: year)
      end

      VCR.use_cassette 'lib/tasks/dam_quantity/quantity_200212' do
        subject.invoke
      end
    end

    # 仮の定義でテストが適当, DamQuantityRecordが正しく作られていることを確認するテストを書く
    context 'when dam has observatory_sign_cd.' do
      it { expect(DamQuantity.count).to eq(2) }
      # it{ expect(DamQuantityRecordYear.count).to eq(3) }
      # it{ expect(DamQuantityRecord.count).to eq(1488) } # 13917
    end

    after do
      VCR.use_cassette 'lib/tasks/dam_quantity/quantity_200212' do
        store = Anemone::Storage.SQLite3('db/test_crawl.db')
        (2002..2004).each do |year|
          (1..12).each do |month|
            start_day = Date.new(year, month, 1)
            end_day = start_day.end_of_month
            # rubocop:disable Style/LineLength
            key_url = "#{Uri::RiverDisasterPreventionInfo::PERIOD_DAM_DATA_URI}?KIND=1&ID=#{tokachi.observatory_sign_cd}&BGNDATE=#{start_day.strftime('%Y%m%d')}&ENDDATE=#{end_day.strftime('%Y%m%d')}&KAWABOU=NO"
            # rubocop:enable Style/LineLength
            Anemone.crawl(key_url) do |anemone|
              anemone.on_every_page do |page|
                store.delete(page.url)
              end
            end
            store.delete(key_url)
          end
        end
      end
    end
  end
end
