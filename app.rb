#encoding: utf-8
require 'rubygems'
require 'sinatra'


get '/' do
	erb "Hello! Blog"			
end

get '/new' do
  erb :new
end