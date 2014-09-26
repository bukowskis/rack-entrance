require 'rack'
require 'ipaddr'

module Rack
  class Entrance

    def initialize(app, options = {})
      @app = app
    end

    def self.internal_cidrs
      ENV['ENTRANCE_INTERNAL_CIDRS'].to_s.split ','
    end

    def call(env)
      @env = env
      request.env['entrance.user_ip']        = user_ip.to_s if user_ip.to_s != ''
      request.env['entrance.internal_cidrs'] = self.class.internal_cidrs
      request.env['entrance.internal']       = internal?
      @app.call env
    end

    def request
      ::Rack::Request.new @env
    end

    def raw_user_ip
      (@env["action_dispatch.remote_ip"] || request.ip).to_s
    end

    def user_ip
      ::IPAddr.new raw_user_ip
    rescue ArgumentError
      nil
    end

    def internal?
      internal_ips.any? { |ip| ip.include?(user_ip) }
    end

    def internal_ips
      @internal_ips ||= self.class.internal_cidrs.map do |cidr|
        begin
          ::IPAddr.new cidr
        rescue ArgumentError
          nil
        end
      end.compact
    end

  end
end
