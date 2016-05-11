#encoding : utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


get '/' do
	erb "Hello! Stranger"			
end

get '/new' do
	erb :new
end

post '/new' do

	content = params[:content]

	erb "#{content}"
end

