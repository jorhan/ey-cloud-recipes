require 'pp'
#
# Cookbook Name:: daemon services
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role]) and !(app_name =~ /.stats./)
     
     #TODO
     #run bundle install in /data/todo/current/app/daemons/gameops_automation/

     execute "update crontab" do 
       command "cd /data/#{app_name}/current/app/daemons/gameops_automation/ && whenever --set 'environment=#{node[:environment][:framework_env]}&path=/data/#{app_name}/current/app/daemons/gameops_automation/' --update-crontab gameops_automation"
     end
      
    
     unless File.exists?("/var/services")
       Dir::mkdir("/var/services")
     end
     unless File.exists?("/var/services/gameops")
       Dir::mkdir("/var/services/gameops")
     end
     unless File.exists?("/var/services/gameops/run")
       File.open("/var/services/gameops/run", 'w') {|f| f.write("") }
     end
     template "/var/services/gameops/run" do
       source "run.erb"
       owner user[:username]
       group user[:username]
       mode 0744
       variables({
           :app_name => app_name,
           :rails_env => node[:environment][:framework_env] 
       })
     end
     
     unless File.exists?("/var/services/gameops/log")
       Dir::mkdir("/var/services/gameops/log")
     end
     unless File.exists?("/var/services/gameops/log/run")
       File.open("/var/services/gameops/log/run", 'w') {|f| f.write("") }
     end    

     template "/var/services/gameops/log/run" do
       source "run_log.erb"
       owner user[:username]
       group user[:username]
       mode 0744
     end    

    

     link "/service/gameops" do
       to "/var/services/gameops"
     end    

    run_for_app(app_name) do |app_name, data|
      execute "svc  -k /service/gameops" do
      end
    end

  end
  

end