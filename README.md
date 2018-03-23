# CounterCacheRails

ActiveRecord child records counter caching on your rails application cache store.

## Installation

Add this line to your rails application's Gemfile:

```ruby
gem 'counter_cache-rails'
```

## Usage

```rb
class Post
  has_many :comments

  counter_cache :comments,
                if: ->(comment) { comment.visible? },
                scope: ->(comments) { comments.visible }

  after_update_comments_count do
    # you can use callbacks on update counter cache
  end

  after_increment_comments_count do
    Redis.current.increment('service:total:comments')
  end

  after_decrement_comments_count do
    Redis.current.decrement('service:total:comments')
  end

  after_cache_comments_count do
    update(comments_count: comments_count)
  end
end

class Comment
  belong_to :post
end

post = Post.create(title: 'sample title', body: 'post body')
post.comments_count # => 0

post.comments.create(body: 'comment body')
post.comments_count # => 1

post.comments_count(force: true) # force reload counter cache
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
