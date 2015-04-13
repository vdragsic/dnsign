### Monkey patch
#
# DropletKit doesn't permit updating of 'data' attribute of domain record,
# even if DigitalOcean API documention says it should.
#
# https://github.com/digitalocean/droplet_kit/blob/master/lib/droplet_kit/mappings/domain_record_mapping.rb#L12
# https://developers.digitalocean.com/documentation/v2/#update-a-domain-record
# https://github.com/digitalocean/droplet_kit/issues/44
#

module DropletKit
  class DomainRecordMapping
    include Kartograph::DSL

    kartograph do
      mapping DomainRecord
      root_key plural: 'domain_records', singular: 'domain_record', scopes: [:read]

      property :id, scopes: [:read]
      property :type, scopes: [:read, :create]
      property :name, scopes: [:read, :create, :update]
      property :data, scopes: [:read, :create, :update] # :update added
      property :priority, scopes: [:read, :create]
      property :port, scopes: [:read, :create]
      property :weight, scopes: [:read, :create]
    end
  end
end
