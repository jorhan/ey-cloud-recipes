require 'pp'
#
# Cookbook Name:: memcached
# Recipe:: default
#
utility_name = "BackendProcess"

node[:applications].each do |app_name,data|
  user = node[:users].first

case node[:instance_role]
 when "solo", "app", "app_master"
   template "/var/services/stats_watcher/run" do
     source "run.erb"
     owner user[:username]
     group user[:username]
     mode 0744
     variables({
         :app_name => app_name,
         :rails_env => node[:environment][:framework_env] 
     })
   end

   link "/service/stats_watcher" do
     to "/var/service/stats_watcher"
   end    
 end
end
if node[:name] == utility_name
  run_for_app(appname) do |app_name, data|
    execute "svc -k /service/stats_watcher" do
    end
  end
end