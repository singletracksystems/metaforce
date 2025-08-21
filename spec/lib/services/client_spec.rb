require 'spec_helper'

describe Metaforce::Services::Client do
  include Savon::SpecHelper
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }
  let(:client) { described_class.new(:session_id => 'foobar', :server_url => 'https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh') }

  it_behaves_like 'a client'

  describe '.describe_layout' do
    context 'without a record type id' do
      before do
        savon.expects(:describe_layout).with(message: {'sObjectType' => 'Account'}).returns(fixture(:describe_layout,:success))
      end

      subject { client.describe_layout('Account') }
      it { should be_a Hash }
    end

    context 'with a record type id' do
      before do
        savon.expects(:describe_layout).with(message: {'sObjectType' => 'Account', 'recordTypeID' => '1234'}).returns(fixture(:describe_layout,:success))
      end

      subject { client.describe_layout('Account', '1234') }
      it { should be_a Hash }
    end
  end

  describe '.send_email' do
    before do
      savon.expects(:send_email).with(message: {:messages => { :to_addresses => "foo@bar.com", :subject => "foo", :plain_text_body => "bar" },
                                      :attributes! => { "ins0:messages" => { "xsi:type" => "ins0:SingleEmailMessage" } }}).returns(fixture(:send_email,:success))
    end

    subject { client.send_email(:to_addresses => 'foo@bar.com', subject: 'foo', plain_text_body: 'bar') }
    it { should be_a Hash}
  end
end
