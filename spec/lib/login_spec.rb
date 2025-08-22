require 'spec_helper'

describe Metaforce::Login do
  let(:klass) { described_class.new('foo', 'bar', 'whizbang') }

  describe '.login' do
    before do
      savon.expects(:login).with(:username => 'foo', :password => 'barwhizbang').returns(:success)
    end

    subject { klass.login }
    it { should be_a Hash }
    it 'returns the correct session_id' do
      expect(subject[:session_id]).to eq '00DU0000000Ilbh!AQoAQHVcube9Z6CRlbR9Eg8ZxpJlrJ6X8QDbnokfyVZItFKzJsLH' \
        'IRGiqhzJkYsNYRkd3UVA9.s82sbjEbZGUqP3mG6TP_P8'
    end
    it 'returns the correct metadata_server_url' do
      expect(subject[:metadata_server_url]).to eq 'https://na12-api.salesforce.com/services/Soap/m/23.0/00DU0000000Albh'
    end
    it 'returns the correct server_url' do
      expect(subject[:server_url]).to eq 'https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh'
    end
  end
end
