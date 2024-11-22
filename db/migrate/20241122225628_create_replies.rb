class CreateReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :replies do |t|
      t.text :content
      t.string :author_name
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
