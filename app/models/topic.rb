class Topic < ApplicationRecord
  has_many :replies, dependent: :destroy
  validates :title, presence: true
  validates :author_name, presence: true
end
