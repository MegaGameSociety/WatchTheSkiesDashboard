Watch the Skies Dashboard
[![Build Status](https://travis-ci.org/MegaGameSociety/WatchTheSkiesDashboard.svg?branch=develop)](https://travis-ci.org/MegaGameSociety/WatchTheSkiesDashboard)

For crappy old code see: https://github.com/FifthSurprise/WatchTheSkiesDashboard

This application uses Rails.

Dependencies are managed using Bundler.
If you do not have Bundler:
  
    gem install bundler

Then run the following to start the application:

    bundle install
    bundle exec rake db:setup
    bundle exec rails s

This will start the server.

To start the server locally and setup the test database, you will need postgresql installed with a root/root user.

If you need to reset to seed after creating the database, run rake db:reset

Other rake commands available via rake -T

An important note: Game data is all linked up under the Game model.  Also, users can only belong to one game currently.

To run the tests:

    bundle exec rspec
