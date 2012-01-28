require 'pp'
#
# Cookbook Name:: daemon services
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role]) and app_name == "todo"
     
    
     unless File.exists?("/var/services")
       Dir::mkdir("/var/services")
     end
     unless File.exists?("/var/services/jboss_poll")
       Dir::mkdir("/var/services/jboss_poll")
     end
     unless File.exists?("/var/services/jboss_poll/run")
       File.open("/var/services/jboss_poll/run", 'w') {|f| f.write("") }
     end
     template "/var/services/jboss_poll/run" do
       source "run.erb"
       owner user[:username]
       group user[:username]
       mode 0744
       variables({
           :app_name => app_name,
           :rails_env => node[:environment][:framework_env] 
       })
     end

     unless File.exists?("/var/services/jboss_poll/log")
       Dir::mkdir("/var/services/jboss_poll/log")
     end
     unless File.exists?("/var/services/jboss_poll/log/run")
       File.open("/var/services/jboss_poll/log/run", 'w') {|f| f.write("") }
     end    

     template "/var/services/jboss_poll/log/run" do
       source "run_log.erb"
       owner user[:username]
       group user[:username]
       mode 0744
     end      
    
     link "/service/jboss_poll" do
       to "/var/services/jboss_poll"
     end    

#    run_for_app(app_name) do |app_name, data|
#      execute "restart jboss" do
#        command "svc  -k /service/jboss_poll"
#      end
#    end

  end
  

end