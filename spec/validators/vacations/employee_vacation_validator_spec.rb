require 'rails_helper'

RSpec.describe Vacations::EmployeeVacationValidator, type: :validator do
  describe '#validate' do
    context 'valid object' do
      it 'successfully' do
        employee = create(:employee, hiring_date: Time.zone.today)
        vacation_params = [{ start_date: (Time.zone.today + 1.year).to_s,
                             end_date: (Time.zone.today + (1.year + 29.day)).to_s }]

        expect(described_class.validate(employee, vacation_params)).to be_nil
      end
    end

    context 'invalid' do
      context 'when employee add more the three vacations' do
        it 'raise ToManyVacationsError' do
          employee = create(:employee, hiring_date: Time.zone.today)
          vacation_params = [
            { start_date: (Time.zone.today + 1.day).to_s,
              end_date: (Time.zone.today + 30.day).to_s },
            { start_date: (Time.zone.today + 1.day).to_s,
              end_date: (Time.zone.today + 30.day).to_s },
            { start_date: (Time.zone.today + 1.day).to_s,
              end_date: (Time.zone.today + 30.day).to_s },
            { start_date: (Time.zone.today + 1.day).to_s,
              end_date: (Time.zone.today + 30.day).to_s }
          ]

          expect { described_class.validate(employee, vacation_params) }
            .to raise_error(Vacations::EmployeeVacationValidator::ToManyVacationsError)
        end
      end

      context 'when vacation is to early' do
        it 'raise ToEarlyVacationError' do
          employee = create(:employee, hiring_date: Time.zone.today)
          vacation_params = [{ start_date: (Time.zone.today + 1.day).to_s,
                               end_date: (Time.zone.today + 30.day).to_s }]

          expect { described_class.validate(employee, vacation_params) }
            .to raise_error(Vacations::EmployeeVacationValidator::ToEarlyVacationError)
        end
      end

      context 'when employee already had vacation that year' do
        it 'raise ToEarlyVacationError' do
          employee = create(:employee, hiring_date: Time.zone.today)
          create(:vacation, employee: employee,
                 start_date: (Time.zone.today + (1.year + 60.day)))
          vacation_params = [{ start_date: (Time.zone.today + 1.year).to_s,
                               end_date: (Time.zone.today + (1.year + 30.day)).to_s }]

          expect { described_class.validate(employee, vacation_params) }
            .to raise_error(Vacations::EmployeeVacationValidator::ToEarlyVacationError)
        end
      end
    end

    context 'when vacations sum more then 30 days' do
      context 'when vacation is to early' do
        it 'raise ToManyVacationDaysError' do
          employee = create(:employee, hiring_date: (Time.zone.today - 1.year))
          vacation_params = [
            { start_date: (Time.zone.today + 1.day).to_s,
              end_date: (Time.zone.today + 14.day).to_s },
            { start_date: (Time.zone.today + 15.day).to_s,
              end_date: (Time.zone.today + 25.day).to_s },
            { start_date: (Time.zone.today + 27.day).to_s,
              end_date: (Time.zone.today + 50.day).to_s }
          ]

          expect { described_class.validate(employee, vacation_params) }
            .to raise_error(Vacations::EmployeeVacationValidator::ToManyVacationDaysError)
        end
      end
    end

    context 'when vacations days are invalid' do
      context ' when first vacation has less then 14 days' do
        it 'raise InvalidVacationLengthError' do
          employee = create(:employee, hiring_date: (Time.zone.today - 1.year))
          vacation_params = [
            { start_date: (Time.zone.today + 1.day).to_s,
              end_date: (Time.zone.today + 10.day).to_s },
            { start_date: (Time.zone.today + 15.day).to_s,
              end_date: (Time.zone.today + 25.day).to_s }
          ]

          expect { described_class.validate(employee, vacation_params) }
            .to raise_error(Vacations::EmployeeVacationValidator::InvalidVacationLengthError)
        end
      end
      context ' when any vacation has less then 5 days' do
        it 'raise InvalidVacationLengthError' do
          employee = create(:employee, hiring_date: (Time.zone.today - 1.year))
          vacation_params = [
            { start_date: (Time.zone.today + 1.day).to_s,
              end_date: (Time.zone.today + 17.day).to_s },
            { start_date: (Time.zone.today + 18.day).to_s,
              end_date: (Time.zone.today + 19.day).to_s }
          ]

          expect { described_class.validate(employee, vacation_params) }
            .to raise_error(Vacations::EmployeeVacationValidator::InvalidVacationLengthError)
        end
      end
    end
  end
end
