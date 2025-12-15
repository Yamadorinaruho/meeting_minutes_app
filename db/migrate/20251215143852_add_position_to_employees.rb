class AddPositionToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_reference :employees, :position, null: true, foreign_key: true
  end
end
