module Api
  module V1
    class EmployeesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        employees = Employee.all
        render json: employees, each_serializer: EmployeeSerializer
      end

      def create
        employee = Employee.new(employee_params)
        employee.save!
        render json: employee, serializer: EmployeeSerializer, status: :created
      rescue ActiveRecord::RecordInvalid
        render json: { errors: employee.errors.messages },
               status: :unprocessable_entity
      end

      def update
        employee = Employee.find(params[:id])
        employee.update!(employee_params)
        render json: employee, serializer: EmployeeSerializer, status: :ok

      rescue ActiveRecord::RecordInvalid
        render json: { errors: employee.errors.messages },
               status: :unprocessable_entity
      end
      private

      def employee_params
        params.require(:employee).permit(:name, :role, :hiring_date)
      end
    end
  end
end
