require 'pp'

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role])
    
    package "dev-java/sun-jdk" do
      action :install
    end

    execute "unpackage feedfetcher" do
      command "cd ~ & tar xzvf /data/todo/current/feedfetcher.tar.gz"
    end

    template "~/feedfetcher/conf/feedfetcher.cfg" do
      source "feedfetcher"
      owner user[:username]
      group user[:username]
      mode 0744
    end
  end  
end