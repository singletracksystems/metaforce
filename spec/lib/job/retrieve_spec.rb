require 'spec_helper'

describe Metaforce::Job::Retrieve do
  let(:client) { double('metadata client') }
  let(:job) { described_class.new client }

  describe '.result' do
    let(:response) { Hashie::Mash.new(success: true) }

    before do
      expect(client).to receive(:status).with(job.id, :retrieve).and_return(response)
    end

    subject { job.result }
    it { is_expected.to eq(response) }
  end

  describe '.zip_file' do
    let(:response) { Hashie::Mash.new(success: true, zip_file: 'foobar') }

    before do
      expect(client).to receive(:status).with(job.id, :retrieve).and_return(response)
    end

    subject { job.zip_file.bytes }
    it { is_expected.to eq([126, 138, 27, 106]) }
  end
end
