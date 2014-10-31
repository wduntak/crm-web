require_relative 'rolodex'

require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
	include DataMapper::Resource

	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :note, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

$rolodex = Rolodex.new

#Routes:

#Route to Index
get '/' do
	erb :index, :layout => :layout
end

#Route to Contact List
get '/contacts' do
  erb :contacts, :layout => :layout
end

#Route to Add Contact
get '/contacts/new' do
	erb :new_contact, :layout => :layout
end

#Route to Search Contact
get '/contacts/search' do
	erb :search, :layout => :layout
end

#Post New Contact to Contacts
post '/contacts' do
	new_contact = Contact.create(params[:first_name], params[:last_name], params[:email], params[:note])
	$rolodex.add_contact(new_contact)
	redirect to('/contacts')
end

#Route to Contact information
get '/contacts/:id' do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
    erb :show_contact, :layout => :layout
  else
    raise Sinatra::NotFound
  end
end

#Display to Contact information
put '/contacts/:id' do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

#Get Contact ID to edit
get '/contacts/:id/edit' do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
    erb :edit_contact, :layout => :layout
  else
    raise Sinatra::NotFound
  end
end

#Get Contact ID to Delete
delete "/contacts/:id" do
  @contact = $rolodex.find(params[:id].to_i)
  if @contact
    $rolodex.remove_contact(@contact)
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

