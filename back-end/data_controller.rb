class DataController < ApplicationController
  TEMPERATURE = 'temperature'.freeze 
  NOISE = 'noise'.freeze
  PRESSURE = 'pressure'.freeze
  HUMIDITY = 'humidity'.freeze
  LIGHT = 'light'.freeze

  VALID_METRICS = [TEMPERATURE, NOISE, PRESSURE, HUMIDITY, LIGHT].freeze

  def valid_params?(metrics)
    metrics.all? {|metric| VALID_METRICS.include?(metric)}
  end

  def valid_timestamp?(start_time, stop_time)
    return true if start_time.to_time < stop_time.to_time && start_time.to_time < Time.Now && stop_time.to_time < Time.Now
  end
  
  def sanitize_params(metrics, start_time, stop_time)
    return true if valid_params?(metrics) && valid_timestamp?(start_time, stop_time)
  end

  def connect_influxdb  
  end

end




