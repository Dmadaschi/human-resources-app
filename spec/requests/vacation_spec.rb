require 'rails_helper'

describe 'vacation management' do
  context '#index' do
    it 'renders all vations' do
      vacations = create_list(:vacation, 3)

      get api_v1_vacations_path

      response_json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_json.first[:id]).to eq(vacations.first.id)
      expect(response_json.first[:start_date]).to eq(vacations.first.start_date.to_s)
      expect(response_json.first[:end_date]).to eq(vacations.first.end_date.to_s)
      expect(response_json.second[:id]).to eq(vacations.second.id)
      expect(response_json.second[:start_date]).to eq(vacations.second.start_date.to_s)
      expect(response_json.second[:end_date]).to eq(vacations.second.end_date.to_s)
      expect(response_json.third[:id]).to eq(vacations.third.id)
      expect(response_json.third[:start_date]).to eq(vacations.third.start_date.to_s)
      expect(response_json.third[:end_date]).to eq(vacations.third.end_date.to_s)
    end

    it 'renders empity json' do
      get api_v1_vacations_path

      response_json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_json).to be_blank
    end
  end

  context '#create' do
    context 'with valid parameters' do
      let(:attributes) { attributes_for(:vacation, employee_id: create(:employee).id) }

      before { post api_v1_vacations_path, params: { vacation: attributes } }

      it 'returns status 201' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a vacation' do
        vacation = JSON.parse(response.body, symbolize_names: true)
        expect(vacation[:start_date]).to eq(attributes[:start_date].to_s)
        expect(vacation[:end_date]).to eq(attributes[:end_date].to_s)
      end
    end

    context 'with invalid parameters' do
      it 'returns missing parameters messages' do
        post api_v1_vacations_path, params: { }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Missing parameters')
      end

      it 'returns record invalid messages' do
        post api_v1_vacations_path, params: { vacation: { foo: 'bar' } }
        expect(response).to have_http_status(:unprocessable_entity)
        errors = JSON.parse(response.body, symbolize_names: true)[:errors]
        %i[employee start_date end_date].each do |param|
          expect(errors).to include(param)
        end
      end
    end
  end

  context '#show' do
    context 'renders vacation' do
      it 'successfully' do
        vacation = create(:vacation)

        get "/api/v1/vacations/#{vacation.id}"

        response_json = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_json[:id]).to eq(vacation.id)
        expect(response_json[:start_date]).to eq(vacation.start_date.to_s)
        expect(response_json[:end_date]).to eq(vacation.end_date.to_s)
      end
    end

    context 'with no vacation' do
      it 'returns record not found error' do
        get "/api/v1/vacations/#{100}"

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Record not found')
      end
    end
  end

  context '#destroy' do
    it 'successfully' do
      vacation = create(:vacation)

      delete "/api/v1/vacations/#{vacation.id}"

      expect(response).to have_http_status(:no_content)
      expect(Vacation.all.count).to be_zero
    end

    context 'with no vacation' do
      it 'returns record not found error' do
        delete "/api/v1/vacations/#{100}"

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('Record not found')
      end
    end
  end

  context '#update' do
    context 'updates vacation' do
      it 'successfully' do
        vacation = create(:vacation)

        patch "/api/v1/vacations/#{vacation.id}", params: { vacation: { start_date: Time.zone.today} }

        expect(response).to have_http_status(:ok)
        expect(vacation.reload.start_date).to eq(Time.zone.today)
      end

      context 'with invalid parameters' do
        it 'returns missing parameters messages' do
          vacation = create(:vacation)
          vacation.save

          patch "/api/v1/vacations/#{vacation.id}", params: { }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('Missing parameters')
        end

        it 'returns record invalid messages' do
          vacation = create(:vacation)
          vacation.save

          patch "/api/v1/vacations/#{vacation.id}", params: { vacation: { start_date: nil } }

          expect(response).to have_http_status(:unprocessable_entity)
          errors = JSON.parse(response.body, symbolize_names: true)[:errors]
          expect(errors).to include(:start_date)
        end
      end

      context 'with no vacation' do
        it 'returns record not found error' do
          patch "/api/v1/vacations/#{100}", params: { }

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include('Record not found')
        end
      end
    end
  end
end
