class Program < ApplicationRecord
  # associations
  has_many :enrollments
  has_many :students, through: :enrollments, source: :student
  has_many :teachers, through: :enrollments, source: :teachers
end
