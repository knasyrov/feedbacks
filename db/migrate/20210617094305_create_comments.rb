class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :source_id, null: false, index: true
      t.text :body
      t.bigint :imt_id, null: false, index: true
      t.timestamp :created_date
      t.timestamps
    end
  end
end
