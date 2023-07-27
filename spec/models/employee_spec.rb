require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validates' do
    context 'valid object' do
      it 'successfully' do
        employee = build(:employee, name: 'Maria',
                         role: 'Tech Lead',
                         hiring_date: Time.zone.today)

        expect(employee).to be_valid
      end
    end

    context 'invalid object' do
      it 'successfully' do
        employee = build(:employee, name: nil, role: nil, hiring_date: nil)

        expect(employee).to_not be_valid
        expect(employee.errors.to_a.count).to eq(3)
      end
    end
  end
end
