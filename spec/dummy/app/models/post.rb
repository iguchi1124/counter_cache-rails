class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  counter_cache :comments
end
