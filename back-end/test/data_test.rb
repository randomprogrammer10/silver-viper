require_relative 'test_helper'

class DataTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_healthcheck
		get '/data'
		assert last_response.ok?
    assert_equal "DATA", last_response.body
  end
end
