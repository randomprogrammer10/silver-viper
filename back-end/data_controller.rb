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

  def valid_timestamp?(start_time, stop_time)
    return false if start_time.nil? || stop_time.nil?
    return false unless start_time.to_time < stop_time.to_time && start_time.to_time < Time.Now && stop_time.to_time < Time.Now
  end

  def fetch_data(start_time, stop_time, metrics=nil)
    metrics = VALID_METRICS if metrics.nil?
    InfluxClient.new.get_weather_metric_data(metrics, start_time, stop_time)
  end
end
