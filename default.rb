include_recipe 'recipes/mysql.rb'
include_recipe 'recipes/ruby_build.rb'
include_recipe 'recipes/nginx.rb'
include_recipe 'recipes/github.rb'

execute 'deplory directory' do
 command 'mkdir /var/www'
 command 'chown ec2-user:ec2-user /var/www'
 not_if 'test -e /var/www'
end


template "/etc/profile.d/rails.sh" do
  source "templates/rails.sh"
  command "chmod 755 /etc/profile.d/rails.sh"
end
