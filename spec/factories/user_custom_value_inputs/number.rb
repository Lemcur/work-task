FactoryBot.define do
  factory :user_custom_value_inputs_number, class: "UserCustomValueInputs::Number" do 
    user
    name { Faker::Name.first_name.downcase }
    value { Faker::Number.number }
  end
end
