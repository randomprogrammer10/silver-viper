require_relative 'test_helper'

class DataTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_missing_params_returns_422
    get '/data?foo=bar'
    assert_equal 422, last_response.status
  end

  def test_unsupported_metrics_returns_422
    get '/data?metrics=foo,bar'
    assert_equal 422, last_response.status
  end

  def test_invalid_start_time_returns_422
    get '/data?metrics=temperature&start_time=foo'
    assert_equal 422, last_response.status
  end

  def test_valid_parameters_returns_200
    get '/data?metrics=temperature&start_time=1568350923&stop_time=1571950893'
    assert_equal 422, last_response.status
  end
end
