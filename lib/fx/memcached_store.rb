require 'memcached'

class Memcached
  # The latest version of memcached (0.11) doesn't support hostnames with dashes
  # in their names, so we overwrite it here to be more lenient.
  def set_servers(servers)
    [*servers].each_with_index do |server, index|
      host, port = server.split(":")
      Lib.memcached_server_add(@struct, host, port.to_i)
    end
  end
end

module ActiveSupport
  module Cache
    class LibmemcachedStore < Store
      attr_reader :addresses

      DEFAULT_OPTIONS = {
        :distribution => :consistent,
        :no_block => true,
        :failover => true
      }

      def initialize(*addresses)
        addresses.flatten!
        options = addresses.extract_options!
        addresses = %w(localhost) if addresses.empty?

        @addresses = addresses
        @data = Memcached.new(@addresses, options.reverse_merge(DEFAULT_OPTIONS))
      end

      def read(key, options = nil)
        super
        @data.get(key, marshal?(options))
      rescue Memcached::NotFound
        nil
      rescue Memcached::Error => e
        log_error(e)
        nil
      end

      # Set the key to the given value. Pass :unless_exist => true if you want to
      # skip setting a key that already exists.
      def write(key, value, options = nil)
        super
        method = (options && options[:unless_exist]) ? :add : :set
        @data.send(method, key, value, expires_in(options), marshal?(options))
        true
      rescue Memcached::Error => e
        log_error(e)
        false
      end

      def delete(key, options = nil)
        super
        @data.delete(key)
        true
      rescue Memcached::Error => e
        log_error(e)
        false
      end

      def exist?(key, options = nil)
        !read(key, options).nil?
      end

      def increment(key, amount=1)
        log 'incrementing', key, amount
        @data.incr(key, amount)
      rescue Memcached::Error
        nil
      end

      def decrement(key, amount=1)
        log 'decrementing', key, amount
        @data.decr(key, amount)
      rescue Memcached::Error
        nil
      end

      def delete_matched(matcher, options = nil)
        super
        raise NotImplementedError
      end

      def clear
        @data.flush
      end

      def stats
        @data.stats
      end

      private

        def expires_in(options)
          (options || {})[:expires_in] || 0
        end

        def marshal?(options)
          !(options || {})[:raw]
        end

        def log_error(exception)
          logger.error "MemcachedError (#{exception.inspect}): #{exception.message}" if logger && !@logger_off
        end
    end
  end
end