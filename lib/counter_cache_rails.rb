# frozen_string_literal: true

require 'counter_cache_rails/configuration'
require 'counter_cache_rails/railtie'

module CounterCacheRails
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
