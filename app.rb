#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'blog.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS posts
             (id INTEGER PRIMARY KEY AUTOINCREMENT,
              created_date DATE,
              content TEXT)'
end


get '/' do
  @results = @db.execute 'select * from posts order by id desc'
	erb :index			
end

# post_id считывается из url:
get '/details/:post_id' do #вывод информации о посте
  post_id = params[:post_id]

  results = @db.execute 'select * from posts where id =?', [post_id]
  @row = results[0]
  # потому что results -это массив хэшей
  # (в этом массиве будет один хэш, т.к. id всегда индивидуальный, а выбор по id)
  # @row -это хэш
  erb :details
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  if content.length <= 0
    @error = 'Введите текст поста'
    return erb :new
  end

  @db.execute 'INSERT INTO posts(content, created_date) values(?, datetime())', [content]

  redirect to '/'
end
