desc "Import tweets"
task :import_tweets => :environment do
  puts "Importing tweets"
  # Tweet.import
  puts "done."
end

# task :send_reminders => :environment do
#   User.send_reminders
# end