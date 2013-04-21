#!/usr/bin/env ruby
#coding: utf-8
#
# People of the Soil - MQTT Listener Command Line Executable
# Author: Marcello Seri
#
# usage:
#  ruby CLIrun.rb N
# 
# where: N = 0 for non verbose output
#        N = 1 for verbose output
#        N = 2 for extremely verbose output
#

require 'MQTTinterface'
require 'settings'

################################################################################
# Do you want to run it from CL? Here we go!
#
# script running from command line
#

# create log directory if not present

Dir.mkdir(LOG_DIR) unless File.exists?(LOG_DIR)

if !ARGV.empty? and ( ARGV[0] == "0" or ARGV[0] == "1" or ARGV[0] == "2" )
    dbgLvl = eval(ARGV[0])
else 
    dbgLvl = DEBUG_LVL
end

listenToMQTTForSoilData(BROKER_ADDRESS,BROKER_PORT,TOPIC,DATAM_ADDRESS,LOG_DIR+LOG_FILE,dbgLvl)
