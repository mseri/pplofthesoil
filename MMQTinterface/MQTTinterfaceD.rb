#coding: utf-8
#
# People of the Soil - MQTT Listener Daemon Core
# Author: Marcello Seri
# 
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Marcello Seri wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return Poul-Henning Kamp
# ----------------------------------------------------------------------------
#

# Demonized version of the MQTT listener. You can run it and control it with:
#  ruby MQTTinterface-daemon.rb [start|stop|status|reload|run]

require File.dirname(__FILE__) + '/MQTTinterface'

mqtt = MQTT::Client.new(BROKER_ADDRESS, BROKER_PORT)
mqtt.connect do
  mqtt.subscribe(TOPIC)
  
  loop do
    topic,message = mqtt.get
    
    # output for log file
    puts "[#{Time.now.to_s}] Mqtt new message published on Topic:#{topic}" if DEBUG_LVL >= 2 # Message:#{message}
    
    elaborateMQTTMessage(message, DATAM_ADDRESS, LOG_DIR+LOG_FILE, DEBUG_LVL)
    
  end
end