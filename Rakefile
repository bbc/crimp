$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end

task default: [:specs]
