# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password node['fundingcircle']['database']['root_password']
  action [:create, :start]
end

# Install the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
  action :install
end

# Create the database instance.
mysql_database node['fundingcircle']['database']['dbname'] do
  connection(
    :host => node['fundingcircle']['database']['host'],
    :username => node['fundingcircle']['database']['root_username'],
    :password => node['fundingcircle']['database']['root_password']
  )
  action :create
end

# Add a database user.
mysql_database_user node['fundingcircle']['database']['admin_username'] do
  connection(
    :host => node['fundingcircle']['database']['host'],
    :username => node['fundingcircle']['database']['root_username'],
    :password => node['fundingcircle']['database']['root_password']
  )
  password node['fundingcircle']['database']['admin_password']
  database_name node['fundingcircle']['database']['dbname']
  host node['fundingcircle']['database']['host']
  action [:create, :grant]
end

# Create a path to the SQL file in the Chef cache.
create_tables_script_path = File.join(Chef::Config[:file_cache_path], 'create-tables.sql')

# Write the SQL script to the filesystem.
cookbook_file create_tables_script_path do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Seed the database with a table and test data.
execute "initialize #{node['fundingcircle']['database']['dbname']} database" do
  command "mysql -h #{node['fundingcircle']['database']['host']} -u #{node['fundingcircle']['database']['admin_username']} -p#{node['fundingcircle']['database']['admin_password']} -D #{node['fundingcircle']['database']['dbname']} < #{create_tables_script_path}"
  not_if  "mysql -h #{node['fundingcircle']['database']['host']} -u #{node['fundingcircle']['database']['admin_username']} -p#{node['fundingcircle']['database']['admin_password']} -D #{node['fundingcircle']['database']['dbname']} -e 'describe customers;'"
end
