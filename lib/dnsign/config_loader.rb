require 'optparse'
require 'yaml'

module Dnsign
  class ConfigLoader

    Config = Struct.new :path

    def initialize
      @config = Config.new
    end

    def parse(params)
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: ruby dyndns.rb [options]"

        opts.on("-cCONFIG", "--config=CONFIG", "Path to config file") do |c|
          @config.path = c
        end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end

      opt_parser.parse! params

      return @config
    end

    def load(path)
      config = YAML.load_file path

      # symbolize keys
      config.reduce({}) do |acc, (k,v)|
        acc[k.to_sym] = v
        acc
      end
    end

    def self.parse_and_load(params)
      loader = self.new
      config = loader.parse params
      loader.load config.path
    end

  end
end
