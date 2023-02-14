class UserCustomValueInputs::Base < ApplicationRecord
  self.table_name = "user_custom_value_inputs"
  self.inheritance_column = :type

  belongs_to :user
end
