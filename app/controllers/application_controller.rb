class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing, with: :parameters_missing
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(exeption)
    render json: "Record not found", status: :not_found
  end

  def parameters_missing
    render json: 'Missing parameters', status: :unprocessable_entity
  end
end
