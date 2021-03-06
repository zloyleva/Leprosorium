#encoding : utf-8

#Подключаем гемы
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	#процедура инициализации БД
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	#инициализация БД для каждой страницы
	init_db
end

configure do
	init_db
	#Создать таблицу если она не существует
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" 
				(
					"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
					"created_date" DATE, 
					"content" TEXT
				)'
	@db.execute 'CREATE TABLE IF NOT EXISTS "Comments" 
				(
					"id" INTEGER PRIMARY KEY AUTOINCREMENT, 
					"created_date" DATE, 
					"content" TEXT,
					"post_id" INTEGER
				)'
end

get '/' do

	@results = @db.execute 'select * from Posts order by id desc'

	erb :index	
end

get '/new' do
	erb :new
end

post '/new' do

	content = params[:content]

	@db.execute 'insert into Posts (created_date, content) values (datetime(), ?)',[content]

	if content.size < 1
		@error = 'Enter text of your post'
		return erb :new
	end

	redirect to '/'
end

get '/details/:post_id' do
	post_id = params[:post_id]

	results = @db.execute 'select * from Posts where id = ?', [post_id]
	@row = results[0]

	@comments = @db.execute 'select * from Comments where post_id =? order by id desc',[post_id]

	erb :details
end

post '/details/:post_id' do
	post_id = params[:post_id]
	content = params[:content]

	@db.execute 'insert into 
				Comments 
				(created_date, content, post_id) 
				values 
				(datetime(), ?, ?)',[content, post_id]

	redirect to ('/details/' + post_id)
end