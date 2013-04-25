directory node[:solr][:dir] do
  owner "root"
  mode "0755"
  action :create
end

template "schema.xml" do
  path "#{node[:solr][:dir]}/schema.xml"
  source "schema.xml.erb"
  owner "root"
  group "root"
  mode "0644"
end

remote_file "#{Chef::Config[:file_cache_path]}/solr-#{node[:solr][:version]}.tgz" do
  source "http://data.riakcs.net:8080/solr/solr-#{node[:solr][:version]}.tgz"
  action :create_if_missing
end

bash "install_solr" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf solr-#{node[:solr][:version]}.tgz
    sudo cp -R solr-#{node[:solr][:version]}/* #{node[:solr][:dir]}/
    sudo rm #{node[:solr][:dir]}/example/solr/collection1/conf/schema.xml
    sudo cp #{node[:solr][:dir]}/schema.xml #{node[:solr][:dir]}/example/solr/collection1/conf/schema.xml
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