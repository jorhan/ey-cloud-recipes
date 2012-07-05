require 'pp'


if ['util'].include?(node[:instance_role]) 
#  execute "crontab -r -u deploy" do
#     action :run
#  end
  
   template "/home/deploy/FeedFetcherDeluxe/working/touch_file.sh" do
     source "touch_file.erb"
     owner 'deploy'
     mode 0744
   end

  cron "Stats Touch" do 
    minute '0'
    hour '22' 
    user 'deploy' 
    command 'sh /home/deploy/FeedFetcherDeluxe/working/touch_file.sh'
    #command 'find /home/deploy/FeedFetcherDeluxe/working -name "*-box.xml" -mmin -480 -print0 | xargs -0 touch'
  end 
end 

if ['app_master'].include?(node[:instance_role])  
  cron "Game end" do 
    minute '0'
    hour '0' 
    user 'deploy' 
    command '/usr/bin/curl --header "Host: baseball.fireleague.com" "http://baseball.fireleague.com/service/main/end_game/run_it"'
  end 

  cron "Seasonal Aggregate Stats" do 
    minute '30'
    hour '1' 
    user 'deploy' 
    command 'cd /data/fireleague_mlb/current/; bundle exec rake scp:stats_aggregate:update RAILS_ENV=production'
  end 

  cron "Pricing Overall Delta - PP1" do 
    minute '56'
    hour '20' 
    user 'deploy' 
    command '/usr/bin/curl --header "Host: baseball.fireleague.com" http://baseball.fireleague.com/service/pricing/pricing_populate_overall_delta/run_it?pricing_pool_id=1'
  end 

  cron "Pricing Overall Delta - PP2" do 
    minute '57'
    hour '20'
    user 'deploy' 
    command '/usr/bin/curl --header "Host: baseball.fireleague.com" http://baseball.fireleague.com/service/pricing/pricing_populate_overall_delta/run_it?pricing_pool_id=2'
  end 

  cron "Pricing End Period - PP 1" do 
    minute '7'
    hour '20'
    user 'deploy' 
    command '/usr/bin/curl --header "Host: baseball.fireleague.com" "http://baseball.fireleague.com/service/pricing/pricing_end_period/run_it?pricing_pool_id=1&price_type=DEFAULT&period_schedule_key=BASIC_SEASON_1_DAILY&last_day_of_period_check_param=YES"'
  end   
  
  cron "Pricing End Period - PP 2" do 
    minute '4'
    hour '20'
    user 'deploy' 
    command '/usr/bin/curl --header "Host: baseball.fireleague.com" "http://baseball.fireleague.com/service/pricing/pricing_end_period/run_it?pricing_pool_id=2&price_type=DEFAULT&period_schedule_key=PREMIER_DAILY&last_day_of_period_check_param=YES"'
  end    

  cron "Seasonal Aggregate Score" do 
    minute '30'
    hour '2'
    user 'deploy' 
    command 'curl --header "Host: baseball.fireleague.com" "http://baseball.fireleague.com/service/scoring/scoring_calculate_athlete_season_scores/run_it_season?season_id=4&league_id=all&aggregates=1&league_configuration_id=all"'
  end    

  
#  cron "Trade" do 
#    minute '0'
#    hour '20' 
#    weekday '1'
#    user 'deploy' 
#    command 'cd /data/fireleague_mlb/current/ && bundle exec rake scp:trade:allocate RAILS_ENV=production '
#  end   
end 
