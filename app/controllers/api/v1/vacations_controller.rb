module Api
  module V1
    class VacationsController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        vacations = Vacation.all
        render json: vacations, each_serializer: VacationSerializer, status: :ok
      end

      def create
        vacation = Vacation.new(vacation_params)
        vacation.save!
        render json: vacation, serializer: VacationSerializer, status: :created
      rescue ActiveRecord::RecordInvalid
        render json: { errors: vacation.errors.messages },
               status: :unprocessable_entity
      end

      def update
        vacation = Vacation.find(params[:id])
        vacation.update!(vacation_params)
        render json: vacation, serializer: VacationSerializer, status: :ok

      rescue ActiveRecord::RecordInvalid
        render json: { errors: vacation.errors.messages },
               status: :unprocessable_entity
      end

      def show
        vacation = Vacation.find(params[:id])
        render json: vacation, serializer: VacationSerializer, status: :ok
      end

      def destroy
        Vacation.find(params[:id]).destroy!
        head :no_content
      end

      private

      def vacation_params
        params.require(:vacation).permit(:start_date, :end_date, :employee_id)
      end
    end
  end
end
