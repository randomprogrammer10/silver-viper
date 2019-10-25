require 'influxdb'

class InfluxClient
  HOST = '172.16.83.35'.freeze
  #HOST = 'localhost'.freeze
  PORT = '8086'.freeze
  RETRY_COUNT = 3
  TIME_OUT = 10
  DB_NAME = 'silverviper'.freeze
  TABLE_NAME = 'weather_metrics'.freeze

  def initialize
    url = "http://#{HOST}:#{PORT}/#{DB_NAME}?retry=#{RETRY_COUNT}"
    @influxdb = InfluxDB::Client.new url: url, open_timeout: TIME_OUT
  end

  def get_metrics_data(metrics, start, stop)
    query_string = generate_query_string(metrics.join(','), start, stop)
    @influxdb.query(query_string)
  end

  private

  def generate_query_string(select_query, start, stop)
    start = start.to_i * (10 ** 9)
    stop = stop.to_i * (10 ** 9)

    "SELECT #{select_query} from #{TABLE_NAME} WHERE TIME > #{start} AND TIME <= #{stop}"
  end
end
