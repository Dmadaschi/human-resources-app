module Vacations
  class EmployeeVacationValidator
    class ToManyVacationsError < StandardError; end
    class ToEarlyVacationError < StandardError; end
    class ToManyVacationDaysError < StandardError; end
    class InvalidVacationLengthError < StandardError; end

    def initialize(employee, vacation_params)
      @employee = employee
      @vacation_params = vacation_params
    end

    def self.validate(*args) = new(*args).validate
    def validate = validate_employee

    private

    attr_reader :employee, :vacation_params

    def validate_employee
      raise ToManyVacationsError if to_many_vacations?
      raise ToEarlyVacationError if to_early_vacation?
      raise ToManyVacationDaysError if to_many_vacation_days?
      raise InvalidVacationLengthError if invalid_vacation_days?
    end

    def to_early_vacation?
      return true if (time_between_vacation_and_hiring_date / 365) < 1
      true if (time_between_vacations / 365) < 1
    end

    def to_many_vacations?
      true if vacation_params.count > 3
    end

    def to_many_vacation_days?
      true if total_vacation_days >= 30
    end

    def invalid_vacation_days?
      return true if (sorted_vacations.first[:end_date].to_date - sorted_vacations.first[:start_date].to_date).to_i < 14
      true if vacations_days.map { |days| days < 5 }.any?(true)
    end

    def time_between_vacation_and_hiring_date
      (sorted_vacations.first[:start_date].to_date -
       employee.hiring_date).to_i
    end

    def time_between_vacations
      return 366 if employee_vacations.empty?

      (sorted_vacations.first[:start_date].to_date -
       employee_vacations.sort(&:end_date).last.end_date).to_i
    end

    def vacations_days
      vacation_params.map do |vacation|
        (vacation[:end_date].to_date - vacation[:start_date].to_date).to_i 
      end
    end

    def sorted_vacations
      vacation_params.sort_by { |vacation_param| vacation_param[:start_date] }
    end

    def total_vacation_days = vacations_days.sum
    def employee_vacations = @employee_vacations ||= employee.vacations
  end
end
