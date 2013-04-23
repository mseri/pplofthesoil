#!/usr/bin/env ruby
#coding: utf-8
#
# People of the Soil - MQTT Listener Daemon
# Author: Marcello Seri
#
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Marcello Seri wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------
#

require 'rubygems'
require 'daemons'

require File.dirname(__FILE__) + '/settings.rb'

# create log directory if not present

Dir.mkdir(LOG_DIR) unless File.exists?(LOG_DIR)

#
# Usage:
# ruby MQTTinterface-daemon.rb [start|stop|status|reload|run]
#
# e.g.
# ./MQTTinterface-daemon.rb start
#
# for debugging purpose:
# ./MQTTinterface-daemon.rb run
#
# see http://daemons.rubyforge.org/ for more informations

Daemons.run('MQTTinterfaceD.rb', { :app_name => 'MQTTinterface-daemon', :backtrace => true, :log_output => true, :dir => LOG_DIR})