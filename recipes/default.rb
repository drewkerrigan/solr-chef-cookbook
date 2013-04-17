# package "daemon"

# download a binary release
#remote_file "/tmp/solr-4.2.1.tgz" do
#  source "http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/4.2.1/solr-4.2.1.tgz"
#end

#todo: remove for real thing
execute "move_solr" do
  command "cp /vagrant/solr-4.2.1.tgz /tmp/vagrant-chef-1/solr-4.2.1.tgz"
  cwd "/tmp"
end

# execute "extract" do
#   command "tar zxf solr-4.2.1.tgz"
#   cwd "/tmp"
# end

#execute "run_solr" do
#  command "sudo java -jar start.jar"
#  cwd "/tmp/solr-4.2.1/example"
#end

user node[:solr][:user] do
  action :create
  system true
  shell "/bin/false"
end

directory node[:solr][:dir] do
  owner "root"
  mode "0755"
  action :create
end

directory node[:solr][:log_dir] do
  mode 0755
  owner node[:solr][:user]
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/solr-#{node[:solr][:version]}.tgz" do
  source "http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/#{node[:solr][:version]}/solr-#{node[:solr][:version]}.tgz"
  action :create_if_missing
end

bash "install_solr" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf solr-#{node[:solr][:version]}.tgz
    sudo cp -R solr-#{node[:solr][:version]}/* #{node[:solr][:dir]}/
  EOH
  creates "#{node[:solr][:dir]}/example/start.jar"
end

service "solr" do
  provider Chef::Provider::Service::Upstart
  subscribes :restart, resources(:bash => "install_solr")
  supports :restart => true, :start => true, :stop => true
end

template "solr.upstart.conf" do
  path "/etc/init/solr.conf"
  source "solr.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "solr")
end

service "solr" do
  action [:enable, :start]
end