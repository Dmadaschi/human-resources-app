require 'rails_helper'

describe 'vacation management' do
  context '#create' do
    context 'with valid parameters' do
      it 'returns status 201' do
        employee = create(:employee, hiring_date: (Time.zone.today - 2.year))
        params = {
          vacations: {
            vacation_params: [
              { start_date: Time.zone.today, end_date: (Time.zone.today + 20.day) }
            ],
            employee_id: employee.id 
          }
        }
        post api_v1_vacations_path, params: params
        expect(response).to have_http_status(:created)
      end
    end
  end
end
