class User < ApplicationRecord
  has_many :user_custom_choice_inputs_multiple, class_name: "UserCustomChoiceInputs::Multiple"
  has_many :user_custom_choice_inputs_single, class_name: "UserCustomChoiceInputs::Single"
  has_many :user_custom_value_inputs_number, class_name: "UserCustomValueInputs::Number"
  has_many :user_custom_value_inputs_string, class_name: "UserCustomValueInputs::String"
end
