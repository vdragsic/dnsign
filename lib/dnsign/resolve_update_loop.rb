require 'json'
require 'timers'
require 'net/http'

require 'dnsign/error'
require 'dnsign/ip_resolver'
require 'dnsign/dns_service'

module Dnsign
  class ResolveUpdateLoop

    def initialize(domain, dns_service, ip_resolver, opts={})
      @domain      = domain
      @ip_resolver = ip_resolver
      @dns_service = dns_service
      @timers      = Timers::Group.new

      @verbose     = opts[:verbose]  || true
      @interval    = opts[:interval] || 300
    end

    def kickoff
      if @interval > 0
        @timer = @timers.every( @interval ) { update }
        loop { @timers.wait }
      end
    end

    def update
      real_ip = resolve_real_ip
      dns_ip  = retrieve_dns_ip

      if real_ip != dns_ip
        update_dns_ip(real_ip)
        log "UPDATE:   Public #{real_ip} differs from the resolved #{dns_ip}"
        true
      else
        log "SKIPPING: Public #{real_ip} matches with the resolved #{dns_ip}"
        false
      end
    end

    private

    def resolve_real_ip
      @ip_resolver.resolve
    rescue InvalidResponseFromIpResolver => e
      log e
    end

    def retrieve_dns_ip
      @dns_service.retrieve_ip @domain
    rescue RecordDoesNotExists => e
      log e
    end

    def update_dns_ip(real_ip)
      @dns_service.update_ip @domain, real_ip
    rescue DomainDoesNotExists => e
        log e
    end

    def log(msg)
      if @verbose == true
        puts ["[#{Time.now.utc}]", msg].join ' '
      end
    end

  end
end
