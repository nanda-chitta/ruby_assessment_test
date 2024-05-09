class User < ApplicationRecord
  # associations
  has_many :students, foreign_key: :user_id, class_name: 'Enrollment'
  has_many :teachers, foreign_key: :teacher_id, class_name: 'Enrollment'
  has_many :favorites, through: :students, source: :teacher, class_name: 'User'

  # enum
  enum :kind, Enums::KINDS, prefix: false

  # scope
  scope :enrolled_teachers, ->(user) { Enrollment.where(user: user).distinct }
  scope :enrolled_user_with_teachers, ->(user) {
    Enrollment.where(teacher_id: enrolled_teachers(user).pluck(:teacher_id)).distinct
  }

  # call back for validate kind
  before_update :validate_kind

  # class methods
  class << self
    def favorite_teachers(user)
      where(id: Enrollment.where(user: user, favorite: true).map(&:teacher_id))
    end

    def classmates(user)
      where(id: enrolled_user_with_teachers(user).pluck(:user_id)).where.not(id: user.id)
    end
  end

  private

  def validate_kind
    if kind_changed? && enrollment_exists? && Enums::MATCHED_KIND.include?(kind)
      errors.add(:base, "Kind can not be #{kind} because is teaching in at least one program") if kind.eql?('student')
      errors.add(:base, "Kind can not be #{kind} because is studying in at least one program") if kind.eql?('teacher')
      throw :abort
    end
  end

  def enrollment_exists?
    students.exists? || teachers.exists?
  end
end
