# Automagically configure dd-agent for services that run on engineyard

include_recipe "datadog:dd-agent"

# Update /etc/dd-agent/datadog.conf to work with EngineYard
if node.attribute?("datadog") and node.datadog.attribute?("api_key")
  template "/etc/dd-agent/datadog.conf" do
    source "ey-datadog.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(:api_key => node['datadog']['api_key'], :dd_url => node['datadog']['url'])
    notifies :restart, "service[datadog-agent]", :immediately
  end
else
  raise "Add a ['datadog']['api_key'] attribute to configure this node's Datadog Agent."
end

