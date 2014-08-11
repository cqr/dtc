namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  task(:rollback => :environment) do
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.rollback('db/migrate')
  end
end

desc 'Runs cucumber features for this project'
task :cucumber do
  exec "cucumber features"
end

desc 'Loads up this project\'s environment'
task :environment do
  require File.join(File.dirname(__FILE__), 'environment')
end

desc 'Runs irb in this project\'s context'
task :irb do |t|
  exec "irb -I lib -r '#{File.join(File.dirname(__FILE__), 'environment')}'"
end

desc 'Alias for irb'
task :console => :irb