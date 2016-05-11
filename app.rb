#encoding : utf-8

#Подключаем гемы
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	#процедура инициализации БД
	db = SQLite3::Database.new 'leprosorium.db'
	db.results_as_hash = true
	return db
end

before do
	#инициализация БД для каждой страницы
	db = init_db
end

configure do
	db = init_db
	#Создать таблицу если она не существует
	db.execute 'CREATE TABLE IF NOT EXISTS "Posts" 
				(
					"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
					"created_date" DATE, 
					"content" TEXT
				);'
end

get '/' do
	erb "Hello! Stranger. Welcome to our blog!"			
end

get '/new' do
	erb :new
end

post '/new' do

	content = params[:content]
	if content.size < 1
		@error = 'Enter text of your post'
		return erb :new
	end

	erb "Other"
end

