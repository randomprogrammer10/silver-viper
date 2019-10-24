require 'date'

require_relative 'influx_client'

class DataController
  TEMPERATURE = 'temperature'.freeze
  NOISE = 'noise'.freeze
  PRESSURE = 'pressure'.freeze
  HUMIDITY = 'humidity'.freeze
  LIGHT = 'light'.freeze

  VALID_PARAMS = ['start_time', 'stop_time', 'metrics'].freeze
  VALID_METRICS = [TEMPERATURE, NOISE, PRESSURE, HUMIDITY, LIGHT].freeze

  def valid_metrics?(metrics)
    return true if metrics.nil?
    metrics = metrics.strip.split(",")
    metrics.all? { |metric| VALID_METRICS.include?(metric) }
  end

  def valid_timestamps?(start_time, stop_time)
    return false if start_time.nil? || stop_time.nil?
    return true if start_time < stop_time && stop_time <= DateTime.now
    return false
  end

  def fetch_data(start_time, stop_time, metrics=nil)
    metrics = VALID_METRICS if metrics.nil?
    result = InfluxClient.new.get_metrics_data(metrics, start_time, stop_time)

    # Return only the data values, none of the other metadata
    return result[0]['values']
  end
end
