class User < ApplicationRecord
  has_many :posts
  has_many :comments

  counter_cache :posts
  counter_cache :comments
end
