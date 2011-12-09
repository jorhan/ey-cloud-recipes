require 'pp'
#
# Cookbook Name:: daemon services
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role])
     run_for_app(app_name) do |app_name, data|
       execute "svscan-add-to-inittab" do
       end
       execute "telinit q" do
       end

     end
    
    
     unless File.exists?("/var/services")
       Dir::mkdir("/var/services")
     end
     unless File.exists?("/var/services/service_listener")
       Dir::mkdir("/var/services/service_listener")
     end
     unless File.exists?("/var/services/service_listener/run")
       File.open("/var/services/service_listener/run", 'w') {|f| f.write("") }
     end
    template "/var/services/service_listener/run" do
       source "run.erb"
       owner user[:username]
       group user[:username]
       mode 0744
       variables({
           :app_name => app_name,
           :rails_env => node[:environment][:framework_env] 
       })
     end
     
     unless File.exists?("/var/services/service_listener/log")
       Dir::mkdir("/var/services/service_listener/log")
     end
     unless File.exists?("/var/services/service_listener/log/run")
       File.open("/var/services/service_listener/log/run", 'w') {|f| f.write("") }
     end    
     template "/var/services/service_listener/log/run" do
       source "run_log.erb"
       owner user[:username]
       group user[:username]
       mode 0744
     end    

     link "/service/service_listener" do
       to "/var/services/service_listener"
     end    

    run_for_app(app_name) do |app_name, data|
      execute "svc /service/service_listener" do
      end
    end

  end
  

end