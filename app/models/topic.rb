class Topic < ApplicationRecord
  has_many :replies, dependent: :destroy
  has_rich_text :content
  
  validates :title, presence: true
  validates :author_name, presence: true
end
