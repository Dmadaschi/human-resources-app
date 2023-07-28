module Api
  module V1
    class VacationsController < ApplicationController
      protect_from_forgery with: :null_session

      def create
        vacations = VacationCreator.call(vacation[:vacation_params], vacation[:employee_id])
        render json: vacations, each_serializer: VacationSerializer, status: :created
      rescue ActiveRecord::RecordInvalid
        render json: { errors: vacation.errors.messages },
               status: :unprocessable_entity
      rescue ::Vacations::EmployeeVacationValidator::ToManyVacationDaysError
        render json: { errors: 'to many vacation days' },
               status: :unprocessable_entity
      rescue ::Vacations::EmployeeVacationValidator::ToEarlyVacationError
        render json: { errors: 'to early vacation' },
               status: :unprocessable_entity
      rescue ::Vacations::EmployeeVacationValidator::ToManyVacationsError
        render json: { errors: 'to many vacations' },
               status: :unprocessable_entity
      rescue ::Vacations::EmployeeVacationValidator::InvalidVacationLengthError
        render json: { errors: 'invalid vacation length' },
               status: :unprocessable_entity
      end

      private

      def vacation
        params.require(:vacations)
              .permit(:employee_id, vacation_params: [:start_date, :end_date])
      end
    end
  end
end
