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
     unless File.exists?("/var/services/stats_feeder")
       Dir::mkdir("/var/services/stats_feeder")
     end
     unless File.exists?("/var/services/stats_feeder/run")
       File.open("/var/services/stats_feeder/run", 'w') {|f| f.write("") }
     end
     template "/var/services/stats_feeder/run" do
       source "run.erb"
       owner user[:username]
       group user[:username]
       mode 0744
     end

     link "/service/stats_feeder" do
       to "/var/services/stats_feeder"
     end    

    run_for_app(app_name) do |app_name, data|
      execute "svc -k /service/stats_feeder" do
      end
    end

  end
  

end