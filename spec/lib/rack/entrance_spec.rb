require 'spec_helper'

describe Rack::Entrance do
  include Rack::Test::Methods

  let(:inner_app) do
    lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All good!']] }
  end

  let(:app) { Rack::Entrance.new(inner_app) }

  context 'internal request' do
    before do
      ENV['ENTRANCE_INTERNAL_IPS'] = '127.0.0.1'
      get '/'
    end

    it 'sets internal to true' do
      last_request.env['entrance.internal'].should be_true
    end
  end

  context 'external request' do
    before do
      ENV['ENTRANCE_INTERNAL_IPS'] = '192.0.2.21,203.0.113.255'
      get '/'
    end

    it 'sets internal to false' do
      last_request.env['entrance.internal'].should be_false
    end
  end

  context 'no env variable set' do
    before do
      ENV['ENTRANCE_INTERNAL_IPS'] = nil
      get '/'
    end

    it 'sets internal to false' do
      last_request.env['entrance.internal'].should be_false
    end
  end

end
