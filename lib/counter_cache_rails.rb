# frozen_string_literal: true

require 'counter_cache_rails/configuration'
require 'counter_cache_rails/railtie'

module CounterCacheRails
  class << self
    def configuration
      @configuration ||= Configuration.new(
        expires_in: 1.hour
      )
    end

    def configure
      yield configuration
    end
  end
end
