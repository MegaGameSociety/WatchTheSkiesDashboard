desc "Import tweets"
task :import_tweets => :environment do
  puts "Importing tweets"
  # Tweet.import
  puts "done."
end

desc "Update messages"
task :update_messages => :environment do
  puts "Updating message visibility."
  Message.update_all(visible: true)
end

# task :send_reminders => :environment do
#   User.send_reminders
# end

namespace :jobs do
  task work: :environment do |t|
  end
end