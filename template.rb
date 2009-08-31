# Rails Edge
system "git init"
system "git submodule add git://github.com/rails/rails.git vendor/rails"
system "git submodule init"
system "git submodule update"

# Gems
gem "haml"
gem "chriseppstein-compass", :lib => "compass"
gem "authlogic"
gem "mislav-will_paginate", :lib => "will_paginate"
gem "sprockets"
gem "metaid"

# DataMapper
gem "addressable", :lib => "addressable/uri"
gem "do_postgres"
gem "do_mysql"
gem "do_sqlite3"
gem 'dm-validations'
gem 'dm-timestamps'
gem "rspec", :lib => false
gem "rspec-rails", :lib => false
gem "rails_datamapper"
gem 'gravtastic'

system "rake gems:install"

# Haml and Compass
system "haml --rails ."
system "compass --rails -f blueprint ."

system 'script/plugin install git://github.com/quinn/sprockets-rails.git'
system 'script/plugin install git://github.com/collin/rails-action-args.git'
system 'script/plugin install git://github.com/rubypond/semantic_form_builder.git'

route "SprocketsApplication.routes(map)"
route "CufonRails.routes(map)"


route "map.welcome '/', :controller => 'welcome', :action => 'index'"
route "map.resources :users"
route "map.resource :user_session"

system "mkdir vendor/javascripts"

# Cleanup
system "rm README"
system "rm public/index.html"
system "rm public/favicon.ico"
system "rm public/javascripts/*"
system "rm public/stylesheets/semantic_forms.css"

# Database
system "rake db:automigrate"
