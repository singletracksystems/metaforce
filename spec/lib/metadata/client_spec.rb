require 'spec_helper'

describe Metaforce::Metadata::Client do
  include Savon::SpecHelper
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }
  let(:client) { described_class.new(:session_id => 'foobar', :metadata_server_url => 'https://na12-api.salesforce.com/services/Soap/u/23.0/00DU0000000Ilbh') }

  it_behaves_like 'a client'

  describe '.deploy' do
    subject { client.deploy File.expand_path('../../path/to/zip') }
    it { should be_a Metaforce::Job::Deploy }
  end

  describe '.retrieve' do
    subject { client.retrieve }
    it { should be_a Metaforce::Job::Retrieve }
  end

  describe '.retrieve_unpackaged' do
    let(:manifest) { Metaforce::Manifest.new(:custom_object => ['Account']) }
    subject { client.retrieve_unpackaged(manifest) }
    it { should be_a Metaforce::Job::Retrieve }
  end

  let(:message) { { :queries => [{ :type => 'ApexClass' }] } }
  let(:method) { :list_metadata }
  let(:result) { :objects }

  describe 'with savon mock' do

  before(:each) do
    savon.expects(method).with(message: message).returns(fixture(method,result))
  end

  describe '.list_metadata' do
    context 'with a single symbol' do
      let(:message) { { :queries => [{ :type => 'ApexClass' }] }}

      subject { client.list_metadata(:apex_class) }
      it { should be_an Array }
    end

    context 'with a single string' do
      subject { client.list_metadata('ApexClass') }
      it { should be_an Array }
    end
  end

  describe '.describe' do
    let(:method) { :describe_metadata }
    let(:result) { :success }
    context 'with no version' do

    let(:message) { {}  }
      subject { client.describe }
      it { should be_a Hash }
    end

    context 'with a version' do
    let(:message) { { :api_version => '18.0' }  }

      subject { client.describe('18.0') }
      it { should be_a Hash }
    end
  end

  describe '.status' do
    let(:method) { :check_status }
    let(:result) { :done }
    let(:message) { { :ids => ['1234'] }  }
    context 'with a single id' do
      subject { client.status '1234' }
      it { should be_a Hash }
    end
  end

  describe '._deploy' do
    let(:method) { :deploy }
    let(:result) { :in_progress }
    let(:message) { { :zip_file => 'foobar', :deploy_options => {} }  }

    subject { client._deploy('foobar') }
    it { should be_a Hash }
  end


  describe '._retrieve' do
    let(:options) { double('options') }
    let(:method) { :retrieve }
    let(:result) { :in_progress }
    let(:message) { { :retrieve_request => options } }

    subject { client._retrieve(options) }
    it { should be_a Hash }
  end



  describe '._create' do
    let(:method) { :create }
    let(:result) { :in_progress }
    let(:message) { { :metadata => [{:full_name => 'component', :label => 'test', :content => "Zm9vYmFy\n"}], :attributes! => {'ins0:metadata' => {'xsi:type' => 'ins0:ApexComponent'}} } }

    subject { client._create(:apex_component, :full_name => 'component', :label => 'test', :content => 'foobar') }
    it { should be_a Hash }
  end

  describe '._delete' do
    let(:method) { :delete }
    let(:result) { :in_progress }
    let(:message) { { :metadata => [{:full_name => 'component'}], :attributes! => {'ins0:metadata' => {'xsi:type' => 'ins0:ApexComponent'}} } }

    context 'with a single name' do

      subject { client._delete(:apex_component, 'component') }
      it { should be_a Hash }
    end

    context 'with multiple' do
      let(:method) { :delete }
      let(:result) { :in_progress }
      let(:message) { { :metadata => [{:full_name => 'component1'}, {:full_name => 'component2'}], :attributes! => {'ins0:metadata' => {'xsi:type' => 'ins0:ApexComponent'}}} }

      subject { client._delete(:apex_component, 'component1', 'component2') }
      it { should be_a Hash }
    end
  end

  describe '._update' do
    let(:method) { :update }
    let(:result) { :in_progress }
    let(:message) { { :metadata => {:current_name => 'old_component', :metadata => [{:full_name => 'component', :label => 'test', :content => "Zm9vYmFy\n"}], :attributes! => {:metadata => {'xsi:type' => 'ins0:ApexComponent'}}}} }

    subject { client._update(:apex_component, 'old_component', :full_name => 'component', :label => 'test', :content => 'foobar') }
    it { should be_a Hash }
  end
end
end



