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
u.role = 'SuperAdmin'
u.save

# Create the user's game
u.game= Game.create(
  name: "Watch the Skies Test",
  round: 0,
  control_message: "Welcome",
  activity: "All is quiet around the world.",
  alien_comm: false,
  time_zone: 'Eastern Time (US & Canada)',
  next_round: (Time.now() + 30*60).in_time_zone("Eastern Time (US & Canada)"),
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
  amount: 0,
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


# Insert Team Roles
TeamRole.create(
  role_name: "head",
  role_display_name: "Head of State",
  role_permissions: ['income']
).save()

TeamRole.create(
  role_name: "deputy",
  role_display_name: "Deputy Head of State",
  role_permissions: ['espionage']
).save()

TeamRole.create(
  role_name: "military",
  role_display_name: "Chief of Defense",
  role_permissions: ['espionage', 'operatives']
).save()

TeamRole.create(
  role_name: "ambassador",
  role_display_name: "UN Delegate",
  role_permissions: []
).save()

TeamRole.create(
  role_name: "alien",
  role_display_name: "Alien",
  role_permissions: ['operatives']
).save()

TeamRole.create(
  role_name: "scientist",
  role_display_name: "Chief Scientist",
  role_permissions: ['research', 'trade', 'rumors']
).save()

TeamRole.create(
  role_name: "editor",
  role_display_name: "Editor",
  role_permissions: []
).save()

Game::COUNTRIES.each do |country|
  team = Team.create(team_name: country)
  #Income starts at 6.
  income = Income.create(game: game, round: game.round, amount: 6)

  income.team_id = team.id
  income.save
end

# Game::Countries doesn't include aliens or media.
Team.create(team_name: 'Aliens').save()
Team.create(team_name: 'GNN').save()
Team.create(team_name: 'SF&T').save()
Team.create(team_name: 'DEN').save()
