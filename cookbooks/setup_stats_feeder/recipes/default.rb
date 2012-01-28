require 'pp'

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role]) 
    
#    package "dev-java/sun-jdk" do
#      action :install
#    end
    
    template "/etc/portage/package.use" do
      source "package.use.erb"
      owner 'root'
      group 'root'
      mode 0744
    end
    
#    run_for_app(app_name) do |app_name, data|
#      execute "emerge dev-lang/perl libperl dev-perl/Compress-Zlib dev-perl/Compress-Raw-Zlib dev-perl/Date-Pcalc dev-perl/DBI dev-perl/File-Slurp dev-perl/HTML-Parser dev-perl/libwww-perl dev-perl/URI dev-perl/XML-LibXML dev-perl/XML-LibXML-Common dev-perl/XML-LibXSLT" do
#      end
#      execute "emerge -O dev-perl/HTML-TokeParser-Simple" do
#      end
#      execute 'perl -MCPAN -e "install HTML::TokeParser"' do
#      end
#    end
    

    #TODO : this command fail in build need to fix it
   
    if File.exists?("/home/deploy") and File.exists?("/data/#{app_name}/current/lib/feedfetcher.tar.gz")
      unless File.exists?("/home/deploy/FeedFetcherDeluxe")
        execute "extract files" do
          command "cd /home/deploy && tar xzvf /data/#{app_name}/current/lib/feedfetcher.tar.gz"
        end

      end
      if File.exists?("/home/deploy/FeedFetcherDeluxe/conf/feedfetcher.cfg")
        template "/home/deploy/FeedFetcherDeluxe/conf/feedfetcher.cfg" do
          source "feedfetcher.erb"
          owner 'deploy'
          group 'deploy'
          mode 0744
        end

        #create folder where the xml are located
        unless File.exists?("/home/deploy/FeedFetcherDeluxe/working")
           Dir::mkdir("/home/deploy/FeedFetcherDeluxe/working")
        end           
      end
      execute "files ownership" do
        command "chown -R deploy:deploy /home/deploy/FeedFetcherDeluxe"
      end      
    end
  end  
end