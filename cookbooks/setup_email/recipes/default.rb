require 'pp'

node[:applications].each do |app_name,data|
  user = node[:users].first
  
     template "/etc/ssmtp/ssmtp.conf" do
       source "ssmtp.conf.erb"
       owner "deploy"
       group "deploy"
       mode 0744
     end    
end