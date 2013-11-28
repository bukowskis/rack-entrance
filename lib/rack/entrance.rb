require 'rack'

module Rack
  class Entrance

    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      ip = (env["action_dispatch.remote_ip"] || request.ip).to_s
      request.env['entrance.ip']           = ip
      request.env['entrance.internal_ips'] = internal_ips
      request.env['entrance.internal']     = internal?(ip)
      @app.call env
    end

    def internal?(ip)
      internal_ips.each do |internal_ip|
        return true if ip.to_s.start_with?(internal_ip)
      end
      false
    end

    def internal_ips
      @internal_ips ||= ENV['ENTRANCE_INTERNAL_IPS'].to_s.split(',')
    end

  end
end
