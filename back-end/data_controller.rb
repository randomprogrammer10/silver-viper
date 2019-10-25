require 'date'

require_relative 'influx_client'

class DataController
  VALID_PARAMS = ['start_time', 'stop_time', 'metrics'].freeze
  VALID_METRICS = %w(
    temperature
    pressure
    humidity
    light
    gas_nh3
    gas_oxidizing
    gas_reducing
    pm_per_dl_0_3
    pm_per_dl_0_5
    pm_per_dl_10_0
    pm_per_dl_1_0
    pm_per_dl_2_5
    pm_per_dl_5_0
    pm_ug_per_m3_10
    pm_ug_per_m3_1_0
    pm_ug_per_m3_2_5
  )

  def valid_metrics?(metrics)
    return true if metrics.nil?
    metrics = metrics.strip.split(",")
    metrics.all? { |metric| VALID_METRICS.include?(metric) }
  end

  def valid_timestamps?(start_time, stop_time)
    return false if start_time.nil? || stop_time.nil?
    return true if start_time < stop_time && stop_time <= Time.now
    return false
  end

  def fetch_data(start_time, stop_time, metrics=nil)
    metrics = VALID_METRICS if metrics.nil?
    result = InfluxClient.new.get_metrics_data(metrics, start_time, stop_time)
    return [] if result.nil? || result.empty?

    result = result[0]['values']
    transform_timestamps(result)

    result
  end

  def transform_timestamps(result)
    result.each { |entry| entry['time'] = Time.parse(entry['time']).to_i }
  end
end
