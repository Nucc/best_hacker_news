require 'rake/testtask'
require_relative 'lib/hacker_news_collector'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'tests'
  t.test_files = FileList['tests/**/*_test.rb']
  t.verbose = true
end

task :send_news_stat, :email do |task, args|
  HackerNewsCollector.send_statistics_to(args[:email])
end

task :default => :test

