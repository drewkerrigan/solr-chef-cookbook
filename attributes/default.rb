default["solr"]["bind_address"] = node['ipaddress']
default["solr"]["bind_port"] = "8983"
default["solr"]["version"] = "4.2.1"
default["solr"]["dir"] = "/opt/solr"
default["solr"]["schema"] = {
	"id" => {
		"type" => "string", 
		"indexed" => "true",
		"stored" => "true",
		"required" => "true",
		"multiValued" => "false"}
}