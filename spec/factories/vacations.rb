FactoryBot.define do
  factory :vacation do
    start_date { Time.zone.today + 60.day }
    end_date { Time.zone.today - 60.day }

    employee
  end
end
