#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{git}.each do |pkg|
  package pkg do
    action :install
  end
end

directory '/usr/share/plantuml/lib' do
  action :create
  recursive true
end

remote_file '/usr/share/plantuml/lib/plantuml.jar' do
  source 'http://downloads.sourceforge.net/project/plantuml/plantuml.jar?r=http%3A%2F%2Fplantuml.sourceforge.net%2Fdownload.html&ts=1406116490&use_mirror=jaist'
  not_if { File.exists?('/usr/share/plantuml/lib/plantuml.jar') }
end

template '/usr/bin/plantuml' do
  source 'plantuml.erb'
  mode '0755'
end

bash 'alminium-checkout' do
  user 'root'
  environment 'HOME' => '/root'
  code <<SHELL
    yum remove ruby ruby-libs ruby-augeas ruby-shadow libselinux-ruby-shadow -y
    yum update -y
    yum install graphviz graphviz-devel java sphinx -y
    mkdir /opt/
    cd /opt/
    git clone https://github.com/alminium/alminium.git
SHELL
  
  not_if { Dir.exists?('/opt/alminium') }
end

template '/opt/alminium/config/redmine-plugins.lst' do
  source 'redmine-plugins.lst.erb'
end
template '/opt/alminium/inst-script/rhel6/pre-install' do
  source 'pre-install.erb'
  mode '0755'
end

bash 'alminium-install' do
  user 'root'
  environment 'HOME' => '/root'
  code <<SHELL
    cd /opt/alminium
    export ALM_HOSTNAME=#{node['alminium']['ALM_HOSTNAME']}
    export SSL=#{node['alminium']['SSL']}
    export ENABLE_JENKINS=#{node['alminium']['JENKINS']}
    bash ./smelt && touch /root/alminium.install.done
SHELL
  not_if { File.exists?('/root/alminium.install.done') }
end

bash 'alminium-wiki-external-filter' do
  user 'root'
  environment 'HOME' => '/root'
  code <<SHELL
    cd /opt/alminium/plugins
    git clone https://github.com/luckval/wiki_external_filter.git
    cp wiki_external_filter/config/wiki_external_filter.yml ../config/
    cd ..
    bundle install
    bundle exec rake redmine:plugins:migrate RAILS_ENV=production
    chown apache:apache plugins/wiki_external_filter config/wiki_external_filter.yml
    service httpd restart
SHELL
  not_if { Dir.exists?('/opt/alminium/plugins/wiki_external_filter') }
end
