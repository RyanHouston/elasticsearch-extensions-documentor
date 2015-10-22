require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc "Opens a pry session configured to use a local elasticsearch server"
task :console do
  sh "bundle exec pry -I lib -I spec -r elasticsearch-documents -r test_env"
end

