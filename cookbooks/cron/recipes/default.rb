require 'pp'


if ['util'].include?(node[:instance_role]) 
  cron "Stats Touch" do 
    hour '22' 
    user 'deploy' 
    command 'find /home/deploy/FeedFetcherDeluxe/working -name "*-box.xml" -mmin -720 -print0 | xargs -0 touch'
  end 
end 

if ['app_master'].include?(node[:instance_role]) 
  cron "Game end" do 
    hour '23' 
    user 'deploy' 
    command '/usr/bin/curl --header "Host: baseball.fireleague.com" "http://baseball.fireleague.com/service/main/end_game/run_it"'
  end 
  
  cron "Trade" do 
    hour '3' 
    weekday '2'
    user 'deploy' 
    command 'cd /data/fireleague_mlb/current/ && rake scp:trade:allocate RAILS_ENV=production '
  end   
end 
