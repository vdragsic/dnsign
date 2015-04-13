require 'dnsign/dns_services/linode'

RSpec.describe DnsServices::Linode do

  before :all do
    @service = DnsServices::Linode.new access_token: '...'
  end

  describe '#update_ip' do

    it 'creates new domain record' do
      VCR.use_cassette('linode_create_domain_record') do
        ip = @service.update_ip 'foo.floatingpoint.io', '127.0.0.1'
        expect(ip).to eq('127.0.0.1')
      end
    end

    it 'updates existing domain record' do
      VCR.use_cassette('linode_update_domain_record') do
        ip = @service.update_ip 'foo.floatingpoint.io', '127.0.1.1'
        expect(ip).to eq('127.0.1.1')
      end
    end
  end

  describe '#retrieve_ip' do

    it 'fetches existing domain record and returns its IP' do
      VCR.use_cassette('linode_read_domain_record') do
        ip = @service.retrieve_ip 'foo.floatingpoint.io'
        expect(ip).to eq('127.0.0.1')
      end
    end

    it 'returns nil for nonexisting record name' do
      VCR.use_cassette('linode_read_domain_record') do
        ip = @service.retrieve_ip 'bar.floatingpoint.io'
        expect(ip).to be_nil
      end
    end

  end
end
