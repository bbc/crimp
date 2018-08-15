require 'spec_helper'
require 'yaml'
require 'json'

# other libraries could fetch the test data from Github.
io    = File.join(__dir__, 'acceptance_data.yml')
tests = YAML::load_file(io)

describe 'Multiplatform compatibility acceptance tests' do
  tests.each do |test|
    input     = JSON.parse(test['json'].to_json)
    signature = test['signature']
    string    = test['string']

    specify "#{test['desc']} string"  do
      expect(Crimp.to_s(input)).to eq(string)
    end

    specify "#{test['desc']} signature"  do
      expect(Crimp.signature(input)).to eq(signature)
    end
  end
end
