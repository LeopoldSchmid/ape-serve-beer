class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.string :author_name

      t.timestamps
    end
  end
end
