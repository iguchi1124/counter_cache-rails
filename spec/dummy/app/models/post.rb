class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  counter_cache :comments

  scope :countable, -> { where(countable: true) }
end
