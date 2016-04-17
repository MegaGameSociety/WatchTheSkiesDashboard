# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create User
u = User.create(role: "SuperAdmin")
u.email = "wts@wts.com"
u.password='swordfish'
u.password_confirmation='swordfish'
u.save

# Create the user's game
u.game= Game.create(
  name: "Watch the Skies Test",
  role: "SuperAdmin",
  round: 0,
  control_message: "Welcome",
  activity: "All is quiet around the world.",
  alien_comm: false,
  next_round: (Time.now() + 30*60),
  data: {
    rioters: 0,
    paused: true,
  }
)
u.save

# Hold on to reference to the game
game = u.game

#An example message for the database. Probably doesn't need to exist in the final version.
# m = Message.create(
# 	sender: "UK",
# 	recipient: "France",
# 	content: "This is an example message",
# 	round_number: 0,
# 	game_id: g.id
# )

# create initial Terror Item
game.terror_trackers.push(TerrorTracker.create(
  description: "Initial Terror",
  amount: 50,
  round: game.round
  ))

# Create some news message stuff
game.news_messages.push(NewsMessage.create(
  title: "Daily Earth News reports:",
  content: "DEN reported some things",
  round: game.round,
  visible_content:true,
  visible_image:true,
  media_url: "http://megagamesociety.com/images/mainlogo.png",
  media_landscape: false
  ))

game.news_messages.push(NewsMessage.create(
  title: "Global News Network reports:",
  content: "GNN also reported some things.",
  round: game.round,
  visible_content: true,
  visible_image: true
  ))

game.news_messages.push(NewsMessage.create(
  title: "Science & Financial Times reports:",
  content: "Science & Financial Times reported some stuff.",
  round: game.round,
  visible_content:true,
  visible_image: true
  ))

# Income starts at 6
Game::COUNTRIES.each do |country|
  game.incomes.push(Income.create(round: game.round, team_name: country, amount: 6))
end
