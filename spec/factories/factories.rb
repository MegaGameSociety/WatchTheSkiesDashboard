require 'factory_bot_rails'

FactoryBot.define do

  factory :game do
    name "Watch the Skies Test"
    round 1
    control_message "Welcome"
    activity "All is quiet around the world."
    alien_comm false
    time_zone 'Eastern Time (US & Canada)'
    next_round (Time.now() + 30*60).in_time_zone("Eastern Time (US & Canada)")
    data { {
        rioters: 0,
        paused: true,
        alien_comms: false
    } }
    after(:create) do |game|
      first_team = Team.find_by_team_name(Game::COUNTRIES[0])
      second_team = Team.find_by_team_name(Game::COUNTRIES[1])
      game.terror_trackers.push(TerrorTracker.create(
          description: "Initial Terror",
          amount: 0,
          round: game.round
      ))
      game.bonus_credits.push(BonusCredit.create(
          game: game,
          team: first_team,
          round: 0,
          amount: 2,
          recurring: false
      ))
      game.messages.push(Message.create(
          game: game,
          round_number: 1,
          content: "Initial test message.",
          visible: true,
          sender: first_team,
          recipient: second_team
      ))
      game.news_messages.push(NewsMessage.create(
          game: game,
          round: 1,
          content: "Initial test news message.",
          visible_content: true
      ))
      game.public_relations.push(PublicRelation.create(
          game: game,
          round: 1,
          pr_amount: -2,
          description: "First team did something bad!",
          source: "Control",
          team: first_team,
          public: true
      ))
      game.tweets.push(Tweet.create(
          game: game,
          twitter_name: "DEN_Account",
          tweet_id: 1234567890,
          text: "Test tweet message"
      ))
      game.users.push(
          User.create(
              game: game,
              team: first_team,
              role: 'Player',
              email: "wts_player@wts.com",
              password: 'swordfish',
              password_confirmation: 'swordfish'
          ),
          User.create(
              game: game,
              role: 'SuperAdmin',
              email: "wts_admin@wts.com",
              password: 'swordfish',
              password_confirmation: 'swordfish'
          ))
    end
  end

  factory :admin, :class => User do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    role 'SuperAdmin'
    # game FactoryBot.build(:game)
  end

  factory :player, :class => User do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    role 'Player'
  end
end
