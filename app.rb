require 'sinatra'
require 'pg'

load './local_env.rb' if File.exists?('./local_env.rb')
db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

db = PG::Connection.new(db_params)

get '/' do
	phonebook=db.exec('SELECT first_name, last_name, street_address, city, state, zip, cell_phone, home_phone FROM phonebook'); 
	erb :index, locals: {phonebook: phonebook}
end

post '/phonebook' do
	first_name = params[:first_name]
	last_name = params[:last_name]
	street_address = params[:street_address]
	city = params[:city]
	state = params[:state]
	zip = params[:zip]
	cell_phone = params[:cell_phone]
	home_phone = params[:home_phone]

	db.exec("INSERT INTO phonebook(first_name, last_name, street_address, city, state, zip, cell_phone, home_phone) VALUES('#{first_name}', '#{last_name}', '#{street_address}', '#{city}', '#{state}', '#{zip}', '#{cell_phone}', '#{home_phone}')");
	redirect '/'
end

post '/update_column' do

   new_data = params[:new_data]
   old_data = params[:old_data]
   column = params[:table_column]

   case column
   when 'col_first_name'
   	db.exec("UPDATE phonebook SET first_name = '#{new_data}' WHERE first_name = '#{old_data}' ");
   when 'col_last_name'
   	db.exec("UPDATE phonebook SET last_name = '#{new_data}' WHERE last_name = '#{old_data}' ");
   when 'col_address'
   	db.exec("UPDATE phonebook SET street_address = '#{new_data}' WHERE street_address = '#{old_data}' ");
   when 'col_city'
   	db.exec("UPDATE phonebook SET city = '#{new_data}' WHERE city = '#{old_data}' ");
   when 'col_state'
   	db.exec("UPDATE phonebook SET state = '#{new_data}' WHERE state = '#{old_data}' ");
   when 'col_zip'
   	db.exec("UPDATE phonebook SET zip = '#{new_data}' WHERE zip = '#{old_data}' ");
   when 'col_cell'
   	db.exec("UPDATE phonebook SET cell_phone = '#{new_data}' WHERE cell_phone = '#{old_data}' ");
   when 'col_home'
	db.exec("UPDATE phonebook SET home_phone = '#{new_data}' WHERE home_phone = '#{old_data}' ");
	end
   redirect '/'
end

post '/delete_all' do
	db.exec("TRUNCATE phonebook");
	redirect '/'
end