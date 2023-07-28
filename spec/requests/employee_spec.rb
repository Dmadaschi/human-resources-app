require 'rails_helper'

describe 'employee management' do
  context '#index' do
    it 'renders all employees' do
      employees = create_list(:employee, 3)

      get api_v1_employees_path

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_json.first[:name]).to eq(employees.first.name)
      expect(response_json.first[:role]).to eq(employees.first.role)
      expect(response_json.first[:hiring_date]).to eq(employees.first.hiring_date.to_s)
      expect(response_json.second[:name]).to eq(employees.second.name)
      expect(response_json.second[:role]).to eq(employees.second.role)
      expect(response_json.second[:hiring_date]).to eq(employees.second.hiring_date.to_s)
      expect(response_json.third[:name]).to eq(employees.third.name)
      expect(response_json.third[:role]).to eq(employees.third.role)
      expect(response_json.third[:hiring_date]).to eq(employees.third.hiring_date.to_s)
    end

    it 'renders empity json' do
      get api_v1_employees_path

      response_json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_json).to be_blank
    end
  end

  context '#create' do
    context 'with valid parameters' do
      let(:attributes) { attributes_for(:employee) }

      before { post api_v1_employees_path, params: { employee: attributes } }

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a employee' do
        employee = JSON.parse(response.body, symbolize_names: true)
        expect(employee[:name]).to eq(attributes[:name])
        expect(employee[:role]).to eq(attributes[:role])
        expect(employee[:hiring_date]).to eq(attributes[:hiring_date].to_s)
      end
    end

    context 'with invalid parameters' do
      it 'returns missing parameters messages' do
        post api_v1_employees_path, params: { }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Missing parameters')
      end

      it 'returns record invalid messages' do
        post api_v1_employees_path, params: { employee: { foo: 'bar' } }
        expect(response).to have_http_status(:unprocessable_entity)
        errors = JSON.parse(response.body, symbolize_names: true)[:errors]
        %i[name role hiring_date].each do |param|
          expect(errors).to include(param)
        end
      end
    end
  end

  context '#update' do
    context 'updates employee' do
      it 'successfully' do
        employee = create(:employee)
        employee.save

        patch "/api/v1/employees/#{employee.id}", params: { employee: { name: 'Marcia'} }

        expect(response).to have_http_status(:ok)
        expect(employee.reload.name).to eq('Marcia')
      end

      context 'with invalid parameters' do
        it 'returns missing parameters messages' do
          employee = create(:employee)
          employee.save

          patch "/api/v1/employees/#{employee.id}", params: { }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('Missing parameters')
        end

        it 'returns record invalid messages' do
          employee = create(:employee)
          employee.save

          patch "/api/v1/employees/#{employee.id}", params: { employee: { name: nil } }

          expect(response).to have_http_status(:unprocessable_entity)
          errors = JSON.parse(response.body, symbolize_names: true)[:errors]
          expect(errors).to include(:name)
        end
      end

      context 'with no employee' do
        it 'returns record not found error' do
          patch "/api/v1/employees/#{100}", params: { }

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include('Record not found')
        end
      end
    end
  end
end
