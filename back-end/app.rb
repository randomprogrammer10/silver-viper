require 'sinatra'

get '/health' do
    'OK'
end

get '/data' do
    'DATA'
end
