class DataController < ApplicationController
  TEMPERATURE = 'temperature'.freeze 
  NOISE = 'noise'.freeze
  PRESSURE = 'pressure'.freeze
  HUMIDITY = 'humidity'.freeze
  LIGHT = 'light'.freeze

  VALID_METRICS = [TEMPERATURE, NOISE, PRESSURE, HUMIDITY, LIGHT].freeze

  def valid_params?(metrics)
    metrics.keys.each do |metric|
      return false if !VALID_METRICS.include?(metric)
    end
  end

  def valid_timestamp?(start_time, stop_time)
    return true if start_time <= Time.Now && stop_time > Time.Now
  end
  

  def sanitize_params(metrics, start_time, stop_time)
    return true if validate_params?(metrics) && validate_start_time(start_time, stop_time)
  end

  def connect_influxdb  
  end

end




