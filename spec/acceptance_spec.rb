require 'spec_helper'
require 'yaml'
require 'json'

# other libraries could fetch the test data from Github.
file  = File.join(__dir__, 'acceptance_data.yml')
tests = YAML::load_file(file)

describe 'Multiplatform compatibility acceptance tests' do
  tests.each do |test|
    input     = JSON.parse(test['json'].to_json, quirks_mode: true)
    signature = test['signature']
    string    = test['string']

    specify "#{test['desc']} string"  do
      expect(Crimp.notation(input)).to eq(string)
    end

    specify "#{test['desc']} signature"  do
      expect(Crimp.signature(input)).to eq(signature)
    end
  end
end
