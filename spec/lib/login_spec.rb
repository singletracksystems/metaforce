require 'spec_helper'

describe Metaforce::Login do
  include Savon::SpecHelper
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }
  let(:klass) { described_class.new('foo', 'bar', 'whizbang') }

  describe '.login' do
    before do
      savon.expects(:login).with(:message=>{:username => 'foo', :password => 'barwhizbang'}).returns(fixture('login', :success))
    end

    subject { klass.login }
    it { is_expected.to be_a(Hash) }
    it { expect(subject[:session_id]).to eq '00DU0000000Ilbh!AQoAQHVcube9Z6CRlbR9Eg8ZxpJlrJ6X8QDbnokfyVZItFKzJsLH' \
                                  'IRGiqhzJkYsNYRkd3UVA9.s82sbjEbZGUqP3mG6TP_P8' }
    it { expect(subject[:metadata_server_url]).to eq 'https://na12-api.salesforce.com/services/Soap/m/23.0/00DU0000000Albh' }
    it { expect(subject[:server_url]).to eq 'https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh' }
  end
end
