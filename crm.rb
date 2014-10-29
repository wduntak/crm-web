require_relative 'rolodex'
require_relative 'contact'
require 'sinatra'

$rolodex = Rolodex.new

#routes
get '/' do
	@crm_app_name = "The Rolodex"
	erb :index, :layout => :layout
end

get "/contacts" do
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
