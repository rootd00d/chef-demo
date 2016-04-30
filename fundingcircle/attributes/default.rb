def random_password
  require 'securerandom'
  SecureRandom.base64
end

default_unless['fundingcircle']['database']['root_password'] = random_password
default_unless['fundingcircle']['database']['admin_password'] = random_password
