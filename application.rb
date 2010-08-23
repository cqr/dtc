#!/usr/bin/env ruby
require 'sinatra'
load File.join(File.dirname(__FILE__), 'environment.rb')
# Add your application code below this line.

mime_type :cache_manifest, 'text/cache-manifest'

get '/' do
  haml :introduction
end

post '/cuddlers/?' do
  cuddler = Cuddler.new(params[:cuddler])
  if cuddler.save
end

get /\/cuddlers\/near\/(.)*\/(.*)\/?/ do |lat, lng|
  lat, lng = lat.to_f, lng.to_f
  cuddlers = Cuddler.within 25, :of => {:lat => lat, :lng => lng}
  cuddlers.all.to_s
end

get '/cache.manifest' do
  content_type :cache_manifest
  erb :cache_manifest
end

get '/style.css' do
  content_type :css
  sass :'style/style'
end