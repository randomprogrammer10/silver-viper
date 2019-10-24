require 'sinatra'
require 'time'

require_relative 'data_controller'

# Healthcheck
get '/health' do
  [200, 'OK']
end

# The data endpoing
get '/data' do
  controller = DataController.new

  metrics = params[:metrics]
  return 422 unless controller.valid_metrics?(metrics)

  start_time = Time.parse(params[:start_time]).to_i
  stop_time = Time.parse(params[:stop_time]).to_i
  return 422 unless controller.valid_timestamps?(start_time, stop_time)

  return controller.fetch_data(start_time, stop_time, metrics)
rescue StandardError
  return 422
end

# This is the default route that will be applied if there are no matches above
get '/*' do
  send_file(File.join('public', 'index.html'))
end
