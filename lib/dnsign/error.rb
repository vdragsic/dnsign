module Dnsign
  module Error

    class UnsupportedDnsService < StandardError; end
    class DomainDoesNotExists < StandardError; end
    class RecordDoesNotExists < StandardError; end
    class InvalidResponseFromIpResolver < StandardError; end
  end
end
