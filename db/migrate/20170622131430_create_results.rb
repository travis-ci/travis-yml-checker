class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.integer  :build_id
      t.text     :original_config
      t.jsonb    :parsed_config
      t.integer  :repo_id
      t.string   :owner_type
      t.integer  :owner_id
      t.timestamps
    end

    create_table :messages do |t|
      t.string   :level
      t.string   :key
      t.string   :code
      t.jsonb    :args
      t.integer  :result_id
      t.timestamps
    end
  end
end
