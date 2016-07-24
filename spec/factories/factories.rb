require 'factory_girl_rails'

FactoryGirl.define do

  factory :game do
    name "Watch the Skies Test"
    round 0
    control_message "Welcome"
    activity "All is quiet around the world."
    alien_comm false
    time_zone 'Eastern Time (US & Canada)'
    next_round (Time.now() + 30*60).in_time_zone("Eastern Time (US & Canada)")
    data { {rioters: 0,
      paused: true
        }
    }
  end

   factory :admin do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "passsword"
    confirmed_at Date.today
    role 'SuperAdmin'
    game FactoryGirl.build(:game)
  end
end
