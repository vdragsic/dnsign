module Dnsign
  class DnsService

    def initialize(opts={})
    end

    def update_ip(fqdn, ip)
      raise NotImplementedError
    end

    def retrieve_ip(fqdn)
      raise NotImplementedError
    end

    def self.create_from_name(service_name, opts={})
      service_name = service_name.to_sym

      if DnsServices.constants.include? service_name
        DnsServices.const_get(service_name).new opts
      else
        fail Error::UnsupportedDnsService,
        "DNS Service #{service_name} is not supported, choose among #{DnsServices::Constants}"
      end
    end

    protected

    def split_fqdn(fqdn)
      result = /(.*)\.(.*\..*)/.match fqdn
      [result[1], result[2]]
    end
  end
end
