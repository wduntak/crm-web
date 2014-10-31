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

#Routes:

#Route to Index
get '/' do
	erb :index, :layout => :layout
end

#Route to Contact List
get '/contacts' do
	@contacts = Contact.all
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

#Route to Delete Contact
get '/contacts/delete' do
	@contacts = Contact.all
	erb :delete, :layout => :layout
end

#Post New Contact to Contacts
post '/contacts' do
	contact = Contact.create(
		:first_name => params[:first_name],
		:last_name => params[:last_name],
		:email => params[:email],
		:note => params[:note]
		)
	redirect to('/contacts')
end

#Route to Contact information
get '/contacts/:id' do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :show_contact, :layout => :layout
  else
    raise Sinatra::NotFound
  end
end

#Display to Contact information
put '/contacts/:id' do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    @contact.update(
    	:first_name => params[:first_name],
    	:last_name => params[:last_name],
    	:email => params[:email],
    	:note => params[:note]
    	)

    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end

#Get Contact ID to edit
get '/contacts/:id/edit' do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    erb :edit_contact, :layout => :layout
  else
    raise Sinatra::NotFound
  end
end

#Get Contact ID to Delete
delete "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    @contact.destroy
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end


