class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.references :company, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.string :employee_number
      t.string :name
      t.string :email
      t.integer :status
      t.date :retired_at

      t.timestamps
    end
  end
end
