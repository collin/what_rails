# Rails Edge
rake "rails:freeze:edge"
rake "rails:update"

# Gems
gem "haml"
gem "chriseppstein-compass"
gem "authlogic"
gem "mislav-will_paginate"
gem "sprockets"
gem "metaid"

# DataMapper
gem "addressable", :lib => "addressable/uri"
gem "do_postgres"
gem 'dm-validations'
gem 'dm-timestamps'
gem "rspec", :lib => false
gem "rspec-rails", :lib => false
gem "datamapper4rail", :lib => 'datamapper4rails' # excuse the typo

rake "gems:install"

# Haml and Compass
run "script/generate dm_install"
run "haml --rails."
run "compass --rails -f blueprint"

# Sprockets
plugin 'sprockets-rails', 
  :git => 'git@github.com/quinn/sprockets-rails.git',
  :submodule => true

route "SprocketsApplication.routes(map)"
route "CufonApplication.routes(map)"

run "mkdir vendor/javascripts"

# Cleanup
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/javascripts/*"

