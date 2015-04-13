require 'dnsign/ip_resolver'

RSpec.describe Dnsign::IpResolver do

  describe '#resolve' do
    it 'resolves current public ip of the host' do
      VCR.use_cassette('ip_resolver_ip_info_io_response') do
        expect(Dnsign::IpResolver.resolve).to eq('127.0.0.1')
      end
    end
  end

end
