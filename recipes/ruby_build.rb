rbenv_user = "ec2-user"

rbenv_root = "/home/#{rbenv_user}/.rbenv"
profile_path = "/home/#{rbenv_user}/.bash_profile"

# packages ------------------------------------------------

%w( gcc make gcc-c++ openssl-devel readline-devel git).each do |pkg|
  package pkg do
    action :install
  end
end
# rbenv + ruby_build ------------------------------------------------

execute 'install rbenv' do
  command "git clone https://github.com/sstephenson/rbenv.git #{rbenv_root}"
  user rbenv_user
  not_if "test -e #{rbenv_root}"
end

execute 'install ruby-build' do
  command "git clone git://github.com/sstephenson/ruby-build.git #{rbenv_root}/plugins/ruby-build"
  user rbenv_user
  not_if "test -e #{rbenv_root}/plugins/ruby-build"
end

# ruby settging ------------------------------------------------

rbenv_setting = <<"EOS"
# rbenv
export RBENV_ROOT=#{rbenv_root}
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"
EOS

execute "add #{profile_path}" do
  command "echo '#{rbenv_setting}' >> #{profile_path}"
  user rbenv_user
  not_if "test `cat #{profile_path} | grep 'rbenv' -c` != 0"
end

execute 'init rbenv' do
  command "source #{profile_path} && eval \"$(rbenv init -)\""
end

# ruby -------------------------------------------------------------------------

 (node[:rtn_rbenv][:versions]).each do |ruby_version|
   execute "install Ruby #{ruby_version}" do
     command "source #{profile_path} && rbenv install #{ruby_version}"
     not_if "source #{profile_path}; rbenv versions | grep #{ruby_version}"
   end
 end

 (node[:rtn_rbenv][:gems]).each do |gem|
   execute "install #{gem}" do
     command "source #{profile_path}; gem install #{gem}; rbenv rehash"
     not_if "source #{profile_path}; gem list | grep #{gem}"
   end
 end

# glonal -----------------------------------------------------------------------

execute "rbenv global #{node[:rtn_rbenv][:global]}" do
  command "source #{profile_path} && rbenv global #{node[:rtn_rbenv][:global]}"
  user rbenv_user
end
