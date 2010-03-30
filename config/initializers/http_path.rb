require 'net/http'

Net::HTTPResponse.class_eval do
  def self.read_status_line(sock)
    str = sock.readline
    m = /\AHTTP(?:\/(\d+\.\d+))?\s+(\d\d\d)\s*(.*)\z/in.match(str) or
            return ["1.1", "200", "OK"]#raise HTTPBadResponse, "wrong status line: #{str.dump}"
    
    m.captures
  end
end