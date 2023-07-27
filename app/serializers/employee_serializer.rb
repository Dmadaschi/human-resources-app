class EmployeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :role, :hiring_date

  has_many :vacations
end
