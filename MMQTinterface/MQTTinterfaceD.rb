#coding: utf-8
#
# People of the Soil - MQTT Listener Daemon Core
# Author: Marcello Seri
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