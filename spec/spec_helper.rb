require 'rack/test'
require 'rack/entrance'

RSpec.configure do |config|

  include Rack::Test::Methods

  config.raise_errors_for_deprecations!

end
