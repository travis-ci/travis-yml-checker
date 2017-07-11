class IndexMessagesOnLevelAndCreatedAt < ActiveRecord::Migration[5.1]
  def change
    add_index :messages, [:level, :created_at]
  end
end
