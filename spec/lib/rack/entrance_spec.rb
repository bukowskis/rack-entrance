require 'spec_helper'

describe Rack::Entrance do
  let(:next_app) { lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All good!']] } }
  let(:app)      { Rack::Entrance.new next_app }

  let(:user_ip)  { last_request.env['entrance.user_ip'] }
  let(:internal) { last_request.env['entrance.internal'] }
  let(:cidrs)    { last_request.env['entrance.internal_cidrs'] }

  before do
    ENV['ENTRANCE_INTERNAL_CIDRS'] = '192.0.2.0/24,198.51.100.0/32'
  end

  context 'missing ENV' do
    before do
      ENV['ENTRANCE_INTERNAL_CIDRS'] = nil
      get '/'
    end

    it 'knows the user IP' do
      expect(user_ip).to eq '127.0.0.1'
    end

    it 'has no cirds' do
      expect(cidrs).to be_empty
    end

    it 'is external' do
      expect(internal).to be false
    end
  end

  context 'invalid ENV' do
    before do
      ENV['ENTRANCE_INTERNAL_CIDRS'] = 'but,why?,198.51.100.0/24,weird,,'
      get '/'
    end

    it 'knows the user IP' do
      expect(user_ip).to eq '127.0.0.1'
    end

    it 'knows the original cidrs' do
      expect(cidrs).to eq %w(but why? 198.51.100.0/24 weird)
    end

    it 'is external' do
      expect(internal).to be false
    end
  end

  context 'invalid user IP' do
    before do
      get '/', {}, 'action_dispatch.remote_ip' => 'what the?'
    end

    it 'has no user IP' do
      expect(user_ip).to be nil
    end

    it 'knows the cidrs' do
      expect(cidrs).to eq %w(192.0.2.0/24 198.51.100.0/32)
    end

    it 'is external' do
      expect(internal).to be false
    end
  end

  context 'internal request' do
    before do
      get '/', {}, 'action_dispatch.remote_ip' => '192.0.2.42'
    end

    it 'knows the user IP' do
      expect(user_ip).to eq '192.0.2.42'
    end

    it 'knows the cidrs' do
      expect(cidrs).to eq %w(192.0.2.0/24 198.51.100.0/32)
    end

    it 'is internal' do
      expect(internal).to be true
    end
  end

  context 'external request from same subnet in /16 range' do
    before do
      get '/', {}, 'action_dispatch.remote_ip' => '192.0.3.0'
    end

    it 'knows the user IP' do
      expect(user_ip).to eq '192.0.3.0'
    end

    it 'knows the cidrs' do
      expect(cidrs).to eq %w(192.0.2.0/24 198.51.100.0/32)
    end

    it 'is external' do
      expect(internal).to be false
    end
  end

  context 'external request from same subnet in /24 range' do
    before do
      get '/', {}, 'action_dispatch.remote_ip' => '198.51.101.0'
    end

    it 'knows the user IP' do
      expect(user_ip).to eq '198.51.101.0'
    end

    it 'knows the cidrs' do
      expect(cidrs).to eq %w(192.0.2.0/24 198.51.100.0/32)
    end

    it 'is external' do
      expect(internal).to be false
    end
  end

  context 'external request' do
    before do
      get '/', {}, 'action_dispatch.remote_ip' => '203.0.113.99'
    end

    it 'knows the user IP' do
      expect(user_ip).to eq '203.0.113.99'
    end

    it 'knows the cidrs' do
      expect(cidrs).to eq %w(192.0.2.0/24 198.51.100.0/32)
    end

    it 'is external' do
      expect(internal).to be false
    end
  end

end
