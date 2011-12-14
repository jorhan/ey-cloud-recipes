require 'pp'

node[:applications].each do |app_name,data|
  user = node[:users].first

  if ['util'].include?(node[:instance_role])
     run_for_app(app_name) do |app_name, data|
       execute "svscan-add-to-inittab" do
       end
       execute "telinit q" do
       end
       execute "/etc/init.d/rabbitmq restart" do
       end
     end
  end
end