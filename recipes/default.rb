# download a binary release
remote_file "/tmp/solr-4.2.1.tgz" do
  source "http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/4.2.1/solr-4.2.1.tgz"
end

execute "extract" do
  command "tar zxf solr-4.2.1.tgz"
  cwd "/tmp"
end

execute "run_solr" do
  command "java -jar start.jar"
  cwd "/tmp/solr-4.2.1/example"
end
