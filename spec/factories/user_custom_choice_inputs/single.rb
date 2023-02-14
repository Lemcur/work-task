FactoryBot.define do
  factory :user_custom_choice_inputs_single, class: "UserCustomChoiceInputs::Single" do 
    user
    name { Faker::Name.first_name.downcase }
    choices { ["first", "second", "third"] }
    selected { ["second"] }
  end
end
