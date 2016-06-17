desc "Make messages visible"
task :visible => :environment do
  puts "Setting all messages to visible"
  Message.set_visible
  puts "All messages now visible"
end
