require 'rails_helper'

RSpec.describe Vacation, type: :model do
  describe 'validates' do
    context 'valid object' do
      it 'successfully' do
        vacation = build(:vacation, start_date: Time.zone.today,
                                    end_date: Time.zone.today + 20.day)

        expect(vacation).to be_valid
      end
    end

    context 'invalid object' do
      it 'successfully' do
        vacation = build(:vacation, start_date: nil,
                                    employee: nil,
                                    end_date: nil)

        expect(vacation).to_not be_valid
        expect(vacation.errors.to_a.count).to eq(3)
      end
    end
  end
end
