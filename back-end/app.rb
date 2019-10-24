require 'sinatra'
require 'sinatra/json'
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

  start_time = Time.at(params[:start_time].to_i).to_datetime
  stop_time = Time.at(params[:stop_time].to_i).to_datetime
  return 422 unless controller.valid_timestamps?(start_time, stop_time)

  json controller.fetch_data(start_time, stop_time, metrics)
rescue StandardError
  return 422
end

# This is the default route that will be applied if there are no matches above
get '/*' do
  send_file(File.join('public', 'index.html'))
end
