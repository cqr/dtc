#!/usr/bin/env ruby
require 'sinatra'
require 'pp'
load File.join(File.dirname(__FILE__), 'environment.rb')
# Add your application code below this line.

mime_type :cache_manifest, 'text/cache-manifest'

get '/' do
  haml :introduction
end

post '/cuddlers/?' do
  cuddler = Cuddler.new(params[:cuddler])
  if cuddler.save
    ''
  else
    status 422
    'you must not be on this planet, I guess? try again later.'
  end
end

get %r{/cuddlers/near/(.*)/(.*)/?} do |lat, lng|
  lat, lng = lat.to_f, lng.to_f
  cuddlers = Cuddler.within(25, :of => {:lat => lat, :lng => lng}).where('created_at > ?', 1.hour.ago)
  cuddlers.select(:id, :created_at).all.to_json(:only =>[:id, :created_at, :distance])
end

get '/cache.manifest' do
  content_type :cache_manifest
  erb :cache_manifest
end

get '/style.css' do
  content_type :css
  sass :'style/style'
end