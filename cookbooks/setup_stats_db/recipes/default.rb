require 'pp'

node[:applications].each do |app_name,data|
  template "/etc/hosts" do
    source "hosts.erb"
    owner 'root'
    group 'root'
    mode 0744
    variables({
           :app_name => app_name,
           :rails_env => node[:environment][:framework_env] 
    })
  end         

  if ['solo', 'app', 'app_master'].include?(node[:instance_role])
    if File.exists?("/data/nfl_stats/current")
      template "/data/nfl_stats/current/config/database.yml" do
        source "database.yml.erb"
        owner 'deploy'
        group 'deploy'
        mode 0744
        variables({
               :app_name => app_name,
               :rails_env => node[:environment][:framework_env] 
        })
      end   
      
      execute "restart nginx" do 
        command "sudo /etc/init.d/nginx restart"
      end
    end
  end
end