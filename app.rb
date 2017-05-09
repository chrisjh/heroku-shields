require 'sinatra'
require 'open-uri'
require 'digest/sha1'
require 'haml'

def heroku_url
  "https://#{params[:app]}.herokuapp.com/"
end

def badge(status_code)
  case status_code
  when '200' then 'heroku-up-brightgreen'
  when '503' then 'heroku-down-red'
  else
    'heroku-unknown-orange'
  end
rescue => e
  'heroku-unknown-orange'
end

def badge_url(badge)
  "https://img.shields.io/badge/#{badge}.svg"
end

def redirect_to_badge(query)
  begin
  status_code = open(heroku_url).status.first
  rescue OpenURI::HTTPError => error
    response = error.io
    status_code = response.status.first
  end
  redirect badge_url(badge status_code) + query
end

get '/' do
  haml :index
end

get '/badge/:app' do
  app = params[:app]
  "#{request.base_url}/#{app}"
end

get '/:app' do
  response.headers['Cache-Control'] = 'no-cache'
  response.headers['Last-Modified'] = Time.now.httpdate
  response.headers['ETag'] = Time.now.utc.strftime("%s%L")

  redirect_to_badge request.env['rack.request.query_string']
end
