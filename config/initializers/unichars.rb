require 'unichars'

ActiveSupport::Multibyte.proxy_class = Unichars
if RUBY_VERSION >= "1.9"
  module ActiveSupport #:nodoc:
    module CoreExtensions #:nodoc:
      module String #:nodoc:
        # Implements multibyte methods for easier access to multibyte characters in a String instance.
        module Multibyte
          def mb_chars
            Unichars.new(self)
          end
        end
      end
    end
  end
end