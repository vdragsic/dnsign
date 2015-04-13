require 'dnsign/ip_resolvers/ip_info_io.rb'

module Dnsign
  class IpResolver

    def initialize(service=IpResolvers::IpInfoIo, opts={})
      @resolver = service.new self
    end

    def resolve
      @resolver.fetch
    rescue => e
      puts "#{e.class}: #{e.message}"
    end

    def self.resolve(*args)
      self.new(*args).resolve
    end

  end
end
