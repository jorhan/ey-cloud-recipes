require 'pp'
#
# Cookbook Name:: daemon services
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role])
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
      execute "svc /service/stats_watcher" do
      end
    end

  end
  

end