# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = FactoryBot.create(:user)
FactoryBot.create(:user_custom_choice_inputs_multiple, user: user)
FactoryBot.create(:user_custom_choice_inputs_single, user: user)
FactoryBot.create(:user_custom_value_inputs_number, user: user)
FactoryBot.create(:user_custom_value_inputs_string, user: user)