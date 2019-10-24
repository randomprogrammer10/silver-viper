require 'sinatra'

get '/health' do
  [200, 'OK']
end

get '/data' do
  [200, 'DATA']
end

# This is the default route that will be applied if there are no matches above
get '/*' do
  send_file(File.join('public', 'index.html'))
end
