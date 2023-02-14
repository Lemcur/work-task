FactoryBot.define do
  factory :user_custom_value_inputs_string, class: "UserCustomValueInputs::String" do 
    user
    name { Faker::Name.first_name.downcase }
    value { Faker::String.random }
  end
end
