module IpResolvers
  class IpInfoIo

    def initialize(resolver)
      @resolver = resolver
    end

    def fetch
      uri = URI 'http://ipinfo.io/json'

      res = ::Net::HTTP.get_response uri

      if /2../.match res.code
        data = JSON.parse res.body
        data.fetch 'ip'
      else
        raise Error::InvalidResponseFromIpResolverService "Invalid response for #{self.class} with code: #{res.code}; body: #{res.body}"
      end

    end

  end
end
