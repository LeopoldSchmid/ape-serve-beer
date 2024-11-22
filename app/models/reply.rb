class Reply < ApplicationRecord
  belongs_to :topic
  validates :content, presence: true
  validates :author_name, presence: true
end
