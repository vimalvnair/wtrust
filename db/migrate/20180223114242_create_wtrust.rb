class CreateWtrust < ActiveRecord::Migration[5.1]
  def change
    create_table :wtrusts do |t|
      t.decimal :total_gain
      t.decimal :total_investment_val
      t.decimal :total_current_val
      t.decimal :day_gain
      t.decimal :day_gain_percent
      t.decimal :xirr
      t.timestamps
    end
  end
end
