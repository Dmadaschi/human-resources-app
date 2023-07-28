FactoryBot.define do
  factory :vacation do
    start_date { rand(Time.zone.today..(Time.zone.today + 60.day)) }
    end_date { rand((Time.zone.today + 70.day)..(Time.zone.today + 90.day)) }

    employee
  end
end
