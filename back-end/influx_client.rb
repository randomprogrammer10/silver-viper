require 'influxdb'

class InfluxClient

  HOST = 'localhost'.freeze
  PORT = '8086'.freeze
  RETRY_COUNT = '3'.freeze
  TIME_OUT = '10'.freeze
  DB_NAME = 'silverviper'.freeze

  def initialize
    @url = "https://#{HOST}:#{PORT}/#{DB_NAME}?retry=#{RETRY_COUNT}"
    @influxdb = InfluxDB::Client.new url: url, open_timeout: TIME_OUT
  end
end
