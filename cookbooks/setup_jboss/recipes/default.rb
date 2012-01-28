require 'pp'

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role]) 
     unless File.exists?("/var/log/jboss")
       Dir::mkdir("/var/log/jboss")
     end

     template "/home/deploy/jboss-5.0.1.GA/server/web/deploy/statsfeeds_xt_nfl.ear/statsfeeds_xt_nfl.war/WEB-INF/classes/statsfeeds.properties" do
       source "statsfeeds.properties.erb"
       owner "deploy"
       group "deploy"
       mode 0744
       variables({
           :app_name => app_name,
           :rails_env => node[:environment][:framework_env] 
       })
     end    
  end
end