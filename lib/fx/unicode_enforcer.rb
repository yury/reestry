module Fx

  class UnicodeEnforcer
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      force_encoding(req.params)
      @app.call(env)
    end

    def force_encoding(on)
      case on
        when String
          on.dup.force_encoding('utf-8')
        when Array
          on.map(&method(:force_encoding))
        when Hash
          on.each_pair do | k, v |
            on[k] = force_encoding(v)
          end
        else
          on
      end
    end
  end
end
