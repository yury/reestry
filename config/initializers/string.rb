require 'iconv'

class String

  @@encodings = {}
  def convert to, from
    key = "#{from}->#{to}"
    unless @@encodings.has_key? key
      @@encodings[key] = Iconv.new(to, from)
    end
    iconv = @@encodings[key]
    iconv.iconv(self)
  end

  def to_win1251
    to_win1251_from 'utf-8'
  end

  def to_utf8
    to_utf8_from 'windows-1251'
  end

  def win1251
    to_win1251_from 'utf-8'
  end

  def utf8
    to_utf8_from 'windows-1251'
  end

  # converts string to utf-8 encoding from any other
  # charset. Default charset is windows-1251
  def to_utf8_from charset="windows-1251"
    convert "utf-8", charset
  end

  def to_win1251_from charset="utf-8"
    convert "windows-1251", charset
  end

  def to_url_escaped_win1251
    CGI.escape(self.to_win1251)
  end

  def to_url
    url, down = '', self.downcase.strip
    down.each_char { |c| url << (valid_url_symbol(c) || '') }
    url
  end

  def trim
    self.strip.gsub("\n", "").gsub("\r", "")
  end
end