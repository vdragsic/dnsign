require 'linode'
require 'dnsign/dns_service'

module DnsServices
  class Linode < Dnsign::DnsService

    def initialize(opts={})
      @access_token = opts.fetch :access_token
    end

    def update_ip(fqdn, ip)
      record_name, domain_name = split_fqdn fqdn

      if record = fetch_record(domain_name, record_name)
        response = update_record(record.domainid, record.resourceid, record_name, ip)
        handle_record_response response, ip
      else
        domain = fetch_domain(domain_name)
        response = create_record(domain.domainid, record_name, ip)
        handle_record_response response, ip
      end
    end

    def retrieve_ip(fqdn)
      record_name, domain_name = split_fqdn fqdn

      if record = fetch_record(domain_name, record_name)
        record.target
      end
    end

    private

    def client
      @client ||= ::Linode.new api_key: @access_token
    end

    def handle_record_response(response, ip)
      # Linode API only returns resourceid on success
      ip if response.resourceid
    end

    def fetch_domain(domain_name)
      domain = client.domain.list.select {|d| d.domain == domain_name}.first
    end

    def fetch_record(domain_name, record_name)
      domain = fetch_domain domain_name
      client
        .domain
        .resource.list(DomainId: domain.domainid)
        .select {|r| r.name == record_name}.first
    end

    def create_record(domain_id, record_name, ip)
      client.domain.resource.create DomainId: domain_id, Type: 'A', Name: record_name, Target: ip
    end

    def update_record(domain_id, record_id, record_name, ip)
      client.domain.resource.update DomainId: domain_id, ResourceId: record_id, Name: record_name, Target: ip
    end

  end
end
