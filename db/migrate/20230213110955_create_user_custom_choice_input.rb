class CreateUserCustomChoiceInput < ActiveRecord::Migration[7.0]
  def change
    create_table :user_custom_choice_inputs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type, null: false
      t.string :choices, array: true, null: false
      t.string :selected, array: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
