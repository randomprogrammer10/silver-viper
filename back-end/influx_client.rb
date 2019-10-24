require 'influxdb'

class InfluxClient

  HOST = 'localhost'.freeze
  PORT = '8086'.freeze
  RETRY_COUNT = '3'.freeze
  TIME_OUT = '10'.freeze
  DB_NAME = 'silverviper'.freeze
  TABLE_NAME = 'weather_metrics'.freeze

  def initialize
    @url = "https://#{HOST}:#{PORT}/#{DB_NAME}?retry=#{RETRY_COUNT}"
    @influxdb = InfluxDB::Client.new url: url, open_timeout: TIME_OUT
  end

  def get_weather_metric_data(metrics, start, stop)
    select_query = generate_query_select_string(metrics.join(','))
    query_string = generate_query_string(select_query, start, stop)
    influxdb.query query_string
  end

  private

  def generate_query_string(select_query, start, stop)
    query_string = "SELECT #{select_query} from #{TABLE_NAME} WHERE TIME BETWEEN #{start} AND #{stop}"
  end
end
