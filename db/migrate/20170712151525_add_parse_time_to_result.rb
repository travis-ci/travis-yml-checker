class AddParseTimeToResult < ActiveRecord::Migration[5.1]
  def change
    add_column(:results, :parse_time, :float)
  end
end
