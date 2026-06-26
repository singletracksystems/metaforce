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
    allow_any_instance_of(Metaforce::Job).to receive(:sleep)
  end
end

RSpec::Matchers.define :set_default do |option|
  chain :to do |value|
    @value = value
  end

  match do |configuration|
    @actual = configuration.send(option.to_sym)
    values_match?(@value, @actual)
  end

  failure_message do
    "Expected #{option} to be set to #{@value.inspect}, got #{@actual.inspect}"
  end
end

def fixture(folder,fixture_name)
  File.read(File.join(File.dirname(__FILE__), "fixtures/requests/#{folder}/#{fixture_name}.xml"))
end

