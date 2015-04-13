require 'dnsign/resolve_update_loop'

RSpec.describe Dnsign::ResolveUpdateLoop do

  describe '#update' do
    it 'updates IP if real differs from one resolved on DNS service' do
      ip_resolver = instance_double('IpResolver', resolve: '127.0.1.1')
      dns_service = instance_double('DnsService', retrieve_ip: '127.0.0.1', update_ip: '127.0.0.1')

      loop = Dnsign::ResolveUpdateLoop.new 'foo.bar.com', dns_service, ip_resolver, {verbose: false, interval: 0}

      expect(loop.update).to be_truthy
    end

    it 'skip if real differs from one resolved on DNS service' do
      ip_resolver = instance_double('IpResolver', resolve: '127.0.0.1')
      dns_service = instance_double('DnsService', retrieve_ip: '127.0.0.1')

      loop = Dnsign::ResolveUpdateLoop.new 'foo.bar.com', dns_service, ip_resolver, {verbose: false, interval: 0}

      expect(loop.update).to be_falsy
    end
  end

end
