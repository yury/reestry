require 'hpricot'
require 'unichars'

Hpricot.module_eval do

   # XML unescape
  def self.uxs(str)
    str = Unichars.new(str.force_encoding("utf-8")).to_s

    str.to_s.
        gsub(/\&(\w+);/) { [NamedCharacters[$1] || ??].pack("U*") }.
        gsub(/\&\#(\d+);/) { [$1.to_i].pack("U*") }
  end

end