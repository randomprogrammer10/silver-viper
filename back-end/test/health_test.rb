require_relative 'test_helper'

class HealthcheckTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_healthcheck
		get '/health'
		assert last_response.ok?
    assert_equal "OK", last_response.body
  end
end
