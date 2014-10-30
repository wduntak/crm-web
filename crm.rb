require_relative 'rolodex'
require_relative 'contact'
require 'sinatra'

$rolodex = Rolodex.new

$rolodex.add_contact(Contact.new("Johnny", "Bravo", "johnny@bitmakerlabs.com", "Rockstar"))

#routes
get '/' do
	erb :index, :layout => :layout
end

get '/contacts' do
  erb :contacts, :layout => :layout
end

get '/contacts/new' do
	erb :new_contact, :layout => :layout
end

post '/contacts' do
	new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
	$rolodex.add_contact(new_contact)
	redirect to('/contacts')
end

get "/contacts/1000" do
  @contact = $rolodex.find(1000)
  erb :show_contact, :layout => :layout
end


