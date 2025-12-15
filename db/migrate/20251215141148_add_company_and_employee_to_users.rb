class AddCompanyAndEmployeeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :company, null: false, foreign_key: true
    add_reference :users, :employee, null: false, foreign_key: true
  end
end
