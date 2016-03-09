require 'rails_helper'
require 'rake'

describe 'dam_quantity' do
  describe 'dam_quantity:quantity' do
    include_context 'rake'
    let(:task_name) { 'dam_quantity:quantity' }
    let(:tokachi) { FactoryGirl.create(:dam_quantity_with_tokachi) }

    before(:each) do
      FactoryGirl.create(:dam_quantity_with_yubari) # yubariのquantity
      (2002..2004).each do |year|
        tokachi.dam_quantity_record_years.create!(observatory_sign_cd: tokachi.observatory_sign_cd, year: year)
      end
    end

    def rake_invoke
      VCR.use_cassette 'lib/tasks/dam_quantity/quantity_200212' do
        subject.invoke
      end
    end

    # 仮の定義でテストが適当, DamQuantityRecordが正しく作られていることを確認するテストを書く
    context 'when dam has observatory_sign_cd.' do
      it { expect(DamQuantity.count).to eq(2) } # tokachi, yubariのquantity
      it { expect(DamQuantityRecordYear.count).to eq(3) } # 2002, 2003, 2004
      # リアルだと13917件なので、VCR上端折った
      it { expect { rake_invoke }.to change { DamQuantityRecord.count }.to(1488) }
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
