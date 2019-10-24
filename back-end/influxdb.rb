require 'influxdb'

class Influxdb
  RASPBERRY_PI_IP = '172.168.38.35'.freeze
  HOST = 'localhost'.freeze
  PORT = '8086'.freeze
  RETRY_COUNT = '3'.freeze
  TIME_OUT = '10'.freeze
  DB_NAME = 'silverviper'.freeze

  url = "https://#{RASPBERRY_PI_IP}/#{HOST}:#{PORT}/#{DB_NAME}?retry=#{RETRY_COUNT}"
  influxdb = InfluxDB::Client.new url: url, open_timeout: TIME_OUT
  
end
