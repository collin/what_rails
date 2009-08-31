namespace :db do
 
  task :preload_models => :environment do
    Dir[RAILS_ROOT + "/app/models/**/*.rb"].each do |model|
      model.sub!(/.*models\//, '').sub!(/.rb/, '')
      m = ::Extlib::Inflection.classify(model.to_s)
      MODELS << m
      Object.const_get(m)
    end
  end
 
  desc "Perform automigration"
  task :automigrate => :preload_models do
    ::DataMapper.auto_migrate!
  end
 
  desc "Perform non destructive automigration"
  task :autoupgrade => :preload_models do
    ::DataMapper.auto_upgrade!
  end
 
  namespace :migrate do
    task :load => :preload_models do
      gem 'dm-migrations'
      FileList["db/migrations/*.rb"].each do |migration|
        load migration
      end
    end
 
    desc "Migrate up using migrations"
    task :up, :version, :needs => :load do |t, args|
      version = args[:version]
      migrate_up!(version)
    end
 
    desc "Migrate down using migrations"
    task :down, :version, :needs => :load do |t, args|
      version = args[:version]
      migrate_down!(version)
    end
  end
 
  desc "Migrate the database to the latest version"
  task :migrate => 'db:migrate:up'
 
  namespace :session do
    desc "Creates sessions table (for DataMapperStore::Session)"
    task :create => :preload_models do
      DataMapperStore::Session.auto_upgrade!
    end
 
    desc "Clears the sessions table (for DataMapperStore::Session)"
    task :clear => :preload_models do
      DataMapperStore::Session.destroy!
    end
  end
 
end