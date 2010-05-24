require 'erubis/helpers/rails_helper'

class FixedErubis < ::Erubis::Eruby
  def add_preamble(src)
    src << "@output_buffer = '';\n"
  end

  def add_text(src, text)
    src << "@output_buffer << '" << escape_text(text) << "';"
  end

  def add_expr_literal(src, code)
    src << '@output_buffer << (' << code << ').to_s;'
  end

  def add_expr_escaped(src, code)
    src << '@output_buffer << ' << escaped_expr(code) << ';'
  end

  def add_postamble(src)
    src << '@output_buffer.to_s'
  end
end

class String
  def safe_concat(string)
    concat string
  end
end

module AvPatch
  # Rails version of with_output_buffer uses '' as the default buf
  def with_output_buffer(buf = '') #:nodoc:
    super(buf)
  end
end

ActionView::Base.send :include, AvPatch

module ActionView
  class Base
    def self.xss_safe?
      true
    end
  end
end

# fix translation helpers (bug in 2.3.6 will be fixed in 2.3.7)
ActionView::Helpers::TranslationHelper.module_eval do
  def translate(key, options = {})
    options[:raise] = true
    translation = I18n.translate(scope_key_by_partial(key), options)
    translation
  rescue I18n::MissingTranslationData => e
    keys = I18n.send(:normalize_translation_keys, e.locale, e.key, e.options[:scope])
    content_tag('span', keys.join(', '), :class => 'translation_missing')
  end
end



Erubis::Helpers::RailsHelper.engine_class = FixedErubis
#Erubis::Helpers::RailsHelper.init_properties = {}
Erubis::Helpers::RailsHelper.show_src = false       # set true for debugging
Erubis::Helpers::RailsHelper.preprocessing = false   # set true to enable preprocessing