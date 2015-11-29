# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

g = Game.create(
  name: "Watch the Skies Test",
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

#An example message for the database. Probably doesn't need to exist in the final version.
m = Message.create(
	sender: "UK",
	recipient: "France",
	content: "This is an example message",
	round_number: 0,
	game_id: g.id
)

# create initial Terror Item
t = TerrorTracker.create(
  description: "Initial Terror",
  amount: 50,
  round: g.round
  )

# Create some news message stuff
NewsMessage.create(
  title: "Daily Earth News reports:",
  content: "DEN reported some things",
  round: 0,
  visible_content:true,
  visible_image:true,
  media_url: "http://megagamesociety.com/images/mainlogo.png"
  )

NewsMessage.create(
  title: "Global News Network reports:",
  content: "GNN also reported some things.",
  round: 0,
  visible_content: true,
  visible_image: true
  )

NewsMessage.create(
  title: "Science & Financial Times reports:",
  content: "Science & Financial Times reported some stuff.",
  round: 0,
  visible_content:true,
  visible_image: true
  )

u = User.create()
u.email = "wts@wts.com"
u.password='swordfish'
u.password_confirmation='swordfish'
u.save
