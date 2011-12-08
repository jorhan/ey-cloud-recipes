#
# Cookbook Name:: rabbitmq
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first

case node[:instance_role]
 when "solo", "app", "app_master"
   template "/etc/rabbitmq/rabbitmq.conf" do
     source "rabbitmq.conf.erb"
     owner user[:username]
     group user[:username]
     mode 0744
     variables({
         :app_name => app_name,
         :server_names => node[:members]
     })
   end

 end
end
