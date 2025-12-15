class CreatePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :positions do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.integer :hourly_rate
      t.integer :rank

      t.timestamps
    end
  end
end
