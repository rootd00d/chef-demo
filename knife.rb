log_level                :info
log_location             STDOUT
node_name                'ubuntu'
client_key               '/home/ubuntu/cookbooks/ubuntu.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef-server/chef-validator.pem'
chef_server_url          'https://ip-172-31-125-10.us-west-2.compute.internal:443'
syntax_check_cache_path  '/home/ubuntu/cookbooks/syntax_check_cache'
file_cache_path "/home/ubuntu/cookbooks/cache"
cookbook_path "/home/ubuntu/cookbooks"

