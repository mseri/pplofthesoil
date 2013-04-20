mqtt = MQTT::Client.new(brokerAddress, 1883)
mqtt.connect do
  mqtt.subscribe(subscribedTopic)
  loop do
    topic,message = mqtt.get
    
    elaborateMMQTMessage(message, dataManagerAddress, logFile, debugLevel)
  end
end