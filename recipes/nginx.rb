package "nginx" do
  action :install
end

template "/etc/nginx/conf.d/virtual.conf" do
  source "../templates/virtual.conf"
end

service 'nginx' do
  action :restart
end

