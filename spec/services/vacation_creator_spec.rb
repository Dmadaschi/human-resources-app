require 'rails_helper'

RSpec.describe VacationCreator, type: :service do
  describe '#creates vacations' do
    before do
      allow_any_instance_of(Vacations::EmployeeVacationValidator)
        .to receive(:validate).with(any_args).and_return(nil)
    end

    let(:employee) { create(:employee) }

    it 'successfully' do
      vacation_params = [{
        start_date: (Time.zone.today + 1.year).to_s,
        end_date: (Time.zone.today + (1.year + 29.day)).to_s 
      }]
      expect {described_class.call(vacation_params, employee.id) }
        .to change { Vacation.count }.by(1)

      expect(Vacation.last.start_date).to eq((Time.zone.today + 1.year))
      expect(Vacation.last.end_date).to eq((Time.zone.today + (1.year + 29.day)))
    end
  end
end
