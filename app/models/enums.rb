module Enums
  # enum kinds
  KINDS = {
    student: 0,
    teacher: 1,
    student_teacher: 2
  }.freeze

  # included error kind
  MATCHED_KIND = %w[teacher student].freeze
end
