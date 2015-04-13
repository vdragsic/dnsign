require 'droplet_kit'
require 'dnsign/dns_service'

# monkey patch
require 'vendor/droplet_kit'

module DnsServices
  class DigitalOcean < Dnsign::DnsService

    def initialize(opts={})
      @access_token = opts.fetch :access_token
    end

    def update_ip(fqdn, ip)
      name, domain = split_fqdn fqdn

      if existing = fetch_record_by_name(domain, name)
        handle_record_response update_record(existing.id, domain, name, ip)
      else
        handle_record_response create_record(domain, name, ip)
      end
    end

    def retrieve_ip(fqdn)
      name, domain = split_fqdn fqdn

      if record = fetch_record_by_name(domain, name)
        record.data
      end
    end

    private

    def client
      @client ||= DropletKit::Client.new access_token: @access_token
    end

    def handle_record_response(record)
      record.data # ip
    end

    def fetch_record_by_name(domain, record_name)
      # todo: handle non-existing domains

      client
        .domain_records
        .all(for_domain: domain)
        .select {|r| r.name == record_name}
        .first
    end

    def update_record(id, domain, record_name, ip)
      record = DropletKit::DomainRecord.new(name: record_name, data: ip)
      client.domain_records.update(record, for_domain: domain, id: id)
    end

    def create_record(domain, record_name, ip)
      record = DropletKit::DomainRecord.new(type: 'A', name: record_name, data: ip)
      client.domain_records.create(record, for_domain: domain)
    end

  end
end
