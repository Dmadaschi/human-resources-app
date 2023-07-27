FactoryBot.define do
  factory :employee do
    name { 'João' }
    role { 'Analista' }
    hiring_date { Time.zone.today - 60.day }
  end
end
