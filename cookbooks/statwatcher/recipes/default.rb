require 'pp'
#
# Cookbook Name:: daemon services
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role])
     
     unless File.exists?("/var/services")
       Dir::mkdir("/var/services")
     end
     unless File.exists?("/var/services/stats_watcher")
       Dir::mkdir("/var/services/stats_watcher")
     end
     unless File.exists?("/var/services/stats_watcher/run")
       File.open("/var/services/stats_watcher/run", 'w') {|f| f.write("") }
     end
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

     unless File.exists?("/var/services/stats_watcher/log")
       Dir::mkdir("/var/services/stats_watcher/log")
     end
     unless File.exists?("/var/services/stats_watcher/log/run")
       File.open("/var/services/stats_watcher/log/run", 'w') {|f| f.write("") }
     end
    
     template "/var/services/stats_watcher/log/run" do
       source "run_log.erb"
       owner user[:username]
       group user[:username]
       mode 0744
     end    

     link "/service/stats_watcher" do
       to "/var/services/stats_watcher"
     end    

    run_for_app(app_name) do |app_name, data|
      execute "svc  -k /service/stats_watcher" do
      end
    end

  end
  

end