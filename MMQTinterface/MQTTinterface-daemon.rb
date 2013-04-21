#!/usr/bin/env ruby
#coding: utf-8
#
# People of the Soil - MQTT Listener Daemon
# Author: Marcello Seri
#

require 'rubygems'
require 'daemons'

require 'settings'

#
# Usage:
# ruby MQTTinterface-daemon.rb [start|stop|status|reload|run]
#
# e.g.
# ./MQTTinterface-daemon.rb status
# ./MQTTinterface-daemon.rb start
#
# for debugging purpose:
# ./MQTTinterface-daemon.rb run
#
# more on http://daemons.rubyforge.org/

Daemons.run('MQTTinterfaceD.rb', { :app_name => 'MQTTinterface-daemon', :backtrace => true, :log_output => true, :dir => LOG_DIR})