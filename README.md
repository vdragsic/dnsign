# Dnsign

Dnsign is a dynamic DNS updater.

It's a simple command line tool that resolves your public IP address and accordingly updates DNS record on one of the currently supported (Linode, DigitalOcean) DNS services.

## Installation

`gem install dnsign`

## Usage

`dnsign --config /path/to/config.yml`

Example config:

```
dns_service: 'DigitalOcean' # [DigitalOcean|Linode]
dns_token: 'your access token from DNS service'
domain: 'foobar.example.com'
interval: 300 # refresh interval in seconds, defaults to 5 minutes
```

It's important that you already have domain on DNS service. Dnsign will periodically check your public IP and try to update or add DNS record to your domain.

For example above to work, there already must be `example.com` domain on DNS service and Dnsign will try to add/update `A` record `foobar` with currently public IP of the host it's running on.

## Adding support for other DNS services

It should be not to hard to add support for the other DNS services.

Just inherit `Dnsign::DnsService` and implement `update_ip`, `retrieve_ip` and optionally initializer methods. For example take a look at one of the existing services.
