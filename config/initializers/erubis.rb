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


Erubis::Helpers::RailsHelper.engine_class = FixedErubis
#Erubis::Helpers::RailsHelper.init_properties = {}
Erubis::Helpers::RailsHelper.show_src = false       # set true for debugging
Erubis::Helpers::RailsHelper.preprocessing = false   # set true to enable preprocessing