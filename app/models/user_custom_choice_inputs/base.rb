class UserCustomChoiceInputs::Base < ApplicationRecord
  self.table_name = "user_custom_choice_inputs"
  self.inheritance_column = :type

  belongs_to :user
end
