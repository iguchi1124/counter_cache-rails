require 'redis-rails'

ENV['REDIS_URL'] ||= 'redis://localhost:6379'

uri = URI("#{ENV['REDIS_URL']}")
Redis.current = Redis.new(host: uri.host, port: uri.port)
