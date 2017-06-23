class AddRequestId < ActiveRecord::Migration[5.1]
  def change
    add_column(:configs, :request_id, :integer)
  end
end
