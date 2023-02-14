class UserCustomValueInputs::Number < UserCustomValueInputs::Base
  validates_numericality_of :value, allow_nil: true
end
