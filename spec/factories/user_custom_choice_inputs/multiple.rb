FactoryBot.define do
  factory :user_custom_choice_inputs_multiple, class: "UserCustomChoiceInputs::Multiple" do 
    user
    name { Faker::Name.first_name.downcase }
    choices { ["first", "second", "third"] }
    selected { ["second", "third"] }
  end
end
