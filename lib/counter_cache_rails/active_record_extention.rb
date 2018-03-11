# frozen_string_literal: true

module CounterCacheRails
  module ActiveRecordExtention
    extend ActiveSupport::Concern

    included do
      # Enable counter cache for a child association
      #
      # @param tableized_model [Symbol] Name of the child association
      # @param options [Hash]
      # @option options [Proc] :if
      # @option options [Proc] :unless
      # @option options [Proc] :scope
      def self.counter_cache(tableized_model, options = {})
        class_name            = self.to_s.downcase
        child_model_class     = tableized_model.to_s.classify.constantize
        tableized_child_model = tableized_model.to_sym
        primary_key           = self.primary_key.to_sym
        callback_name         = "update_#{tableized_child_model}_count".to_sym

        define_model_callbacks callback_name

        define_method "#{tableized_child_model}_count" do |force: false|
          count = Rails.cache.read(_counter_cache_key(class_name, primary_key, tableized_child_model), raw: true)

          if count.nil? || force
            scope = options[:scope] ? options[:scope].call(self.send(tableized_child_model)) : self.send(tableized_child_model)
            count = scope.count

            Rails.cache.write(
              self._counter_cache_key(class_name, primary_key, tableized_child_model),
              count,
              raw: true
            )
          end

          count.to_i
        end

        define_method "_#{tableized_child_model}_count_incr" do
          run_callbacks callback_name do
            Rails.cache.increment(_counter_cache_key(class_name, primary_key, tableized_child_model))
          end
        end

        define_method "_#{tableized_child_model}_count_decr" do
          run_callbacks callback_name do
            Rails.cache.decrement(_counter_cache_key(class_name, primary_key, tableized_child_model))
          end
        end

        after_create do
          scope = options[:scope] ? options[:scope].call(self.send(tableized_child_model)) : self.send(tableized_child_model)

          Rails.cache.write(
            self._counter_cache_key(class_name, primary_key, tableized_child_model),
            scope.count,
            raw: true
          )
        end

        child_model_class.class_eval do
          after_create do
            next unless options[:if].nil? || options[:if].call(self)
            next if !options[:unless].nil? && options[:unless].call(self)

            self.send(class_name.to_sym).send("_#{tableized_child_model}_count_incr")
          end

          after_destroy do
            next unless options[:if].nil? || options[:if].call(self)
            next if !options[:unless].nil? && options[:unless].call(self)

            self.send(class_name.to_sym).send("_#{tableized_child_model}_count_decr")
          end
        end
      end

      def _counter_cache_key(class_name, primary_key, tableized_child_model)
        '_' + [class_name, self.send(primary_key), tableized_child_model].join('_')
      end
    end
  end
end
