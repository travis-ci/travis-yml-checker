class AddIndices < ActiveRecord::Migration[5.1]
  def change
    add_index :results, [:request_id]
    add_index :results, [:owner_type, :owner_id]
    add_index :messages, [:result_id]
  end
end
