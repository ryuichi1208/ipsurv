#!/bin/env ruby

require 'resolv'
require "./lib/Mod"

class IpSurv
  attr_accessor :ip

  def usage(msg="")
    if ! msg.empty?
      puts msg
    end
    puts "Usage: "
  end

  def initialize ip
    if Resolv::IPv4::Regex !~ ip
      usage "IPアドレスが不正です: #{ip}"
    end
    @ip = ip
  end
  include Mod

  def cmdRouting
    execWhois(@ip)
    execCountryCheck(@ip)
    execDigX(@ip)
    execConnect(@ip)
  end
end

m = IpSurv.new(ARGV[0])
m.cmdRouting
