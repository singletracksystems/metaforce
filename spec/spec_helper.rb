require 'bundler'
Bundler.require :default, :development
require 'pp'
require 'rspec/mocks'
require 'savon/mock/spec_helper'
Dir['./spec/support/**/*.rb'].sort.each {|f| require f}
RSpec.configure do |config|
  config.mock_with :rspec
  config.before(:each) do
    Metaforce.configuration.threading = false
    Metaforce::Job.any_instance.stub(:sleep)
  end
end

RSpec::Matchers.define :set_default do |option|
  chain :to do |value|
    @value = value
  end

  match do |configuration|
    @actual = configuration.send(option.to_sym)
    @actual.should eq @value
  end

  failure_message_for_should do |configuration|
    "Expected #{option} to be set to #{@value.inspect}, got #{@actual.inspect}"
  end
end

def fixture(folder,fixture_name)
  File.read(File.join(File.dirname(__FILE__), "fixtures/requests/#{folder}/#{fixture_name}.xml"))
end

