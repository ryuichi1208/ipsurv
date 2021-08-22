require "net/http"
require "open3"
require "json"
require 'socket'

module Mod
  WELLKNOWN_PORT = [21, 22, 80, 443, 8080, 8443]

  def execWhois(ip)
    puts "\e[31m"
    puts "======== whois ========"
    o, e, s = Open3.capture3("whois #{ip}")
    puts o
  end

  def execCountryCheck(ip)
    puts "\e[32m"
    puts "======== Country Check ========"
    uri = URI.parse("http://ip-api.com/json/#{ip}")
    response = Net::HTTP.get_response(uri)
    if response.code == "200"
      body = JSON.parse(response.body)
      if body["status"] == "success"
        puts <<~EOS
          Country:     #{body["country"]}
          CountryCode: #{body["countryCode"]}
          Region:      #{body["region"]}
          City:        #{body["city"]}
          Org:         #{body["org"]}
          ISP:         #{body["region"]}
          AS:          #{body["as"]}
          timezone:    #{body["timezone"]}

        EOS
      end
    end
  end

  def execDigX(ip)
    puts "\e[34m"
    puts "======== dig -x ========"
    o, e, s = Open3.capture3("dig -x #{ip} +short")
    if o.empty?
      puts "No ptr record"
    else
      puts o
    end
  end

  def execConnect(ip)
    s = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    s.setsockopt("TCP", "NODELAY", 10)
    opt = s.getsockopt("TCP", "NODELAY")
    p opt
    WELLKNOWN_PORT.each do |port|
      s = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
      s.setsockopt(:SOCKET, Socket::TCP_NODELAY, true)
      opt = s.getsockopt(:SOCKET, Socket::TCP_NODELAY)
      puts opt
      sockaddr = Socket.sockaddr_in(port, @ip)
      begin
        s.connect(sockaddr)
      rescue Errno::ECONNREFUSED
        puts "block"
      else
        puts "opne"
      end
    end
  end

end
