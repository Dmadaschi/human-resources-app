FactoryBot.define do
  factory :employee do
    name { 'João' }
    role { 'Analista' }
    hiring_date { rand((Time.zone.today - 180.day)..Time.zone.today) }
  end
end
