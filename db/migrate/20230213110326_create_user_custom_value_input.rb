class CreateUserCustomValueInput < ActiveRecord::Migration[7.0]
  def change
    create_table :user_custom_value_inputs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type, null: false
      t.string :name, null: false
      t.string :value

      t.timestamps
    end
  end
end
