class VacationCreator
  def initialize(vacation_params, employee_id)
    @vacation_params = vacation_params
    @employee_id = employee_id
  end

  def self.call(*args) = new(*args).call
  def call = create_vacations

  private

  attr_reader :employee_id, :vacation_params

  def create_vacations
    Vacations::EmployeeVacationValidator.validate(employee, vacation_params)

    vacation_params.map do
      |vacation| employee.vacations.new(vacation).tap(&:save!)
    end
  end

  def employee = @employee ||= Employee.find(employee_id)
end
