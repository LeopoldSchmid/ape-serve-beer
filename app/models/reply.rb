class Reply < ApplicationRecord
  belongs_to :topic
  has_rich_text :content
  
  validates :author_name, presence: true
end
