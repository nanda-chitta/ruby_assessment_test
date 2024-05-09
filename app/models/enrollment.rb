class Enrollment < ApplicationRecord
  # associations
  belongs_to :user, foreign_key: :user_id
  belongs_to :teacher, foreign_key: :teacher_id, class_name: 'User'
  belongs_to :student, foreign_key: :user_id, class_name: 'User'
  belongs_to :program

  # validates
  validates :user_id,
            uniqueness: {
              scope: %i[teacher_id program_id],
              message: 'has already been enrolled as teacher'
            }
end
