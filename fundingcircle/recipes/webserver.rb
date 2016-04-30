package "apache2" do
  action :install
end

package "php5" do
  action :install
end

package "php-pear" do
  action :install
end

package "php5-mysql" do
  action :install
end

service "apache2" do
  action :restart
end

