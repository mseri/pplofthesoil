#!/usr/bin/env ruby
#coding: UTF-8
#

require 'rubygems'
require 'mqtt'

sleep(3)

# Publish example
MQTT::Client.connect('m2m.eclipse.org') do |c|
   (1..5).each do |i|
      message1 = '{"id": "LaptUKF00001","time": "'+Time.new.ctime+'","lat": "51.56","long": "-0.16","hasAltitude":false,"altitude": "10","hasPH":true,"pH":"4.2","hasMoisture":true,"moisture":"97'+('1'..'9').to_a.shuffle[1]+'","hasTemperature":true,"temperature":"13.'+('1'..'9').to_a.shuffle[1]+'"}'
      message2 = '{"id": "LaptITF00002","time": "'+Time.new.ctime+'","lat": "44.5012","long": "11.345","hasAltitude":false,"altitude": "000","hasPH":true,"pH":"2.7","hasMoisture":true,"moisture":"22'+('1'..'9').to_a.shuffle[1]+'","hasTemperature":true,"temperature":"25.'+('1'..'9').to_a.shuffle[1]+'"}'
      message3 = '{"id": "LaptITF00001","time": "'+Time.new.ctime+'","lat": "43.21","long": "13.26","hasAltitude":true,"altitude": "150","hasPH":true,"pH":"7.2","hasMoisture":true,"moisture":"43'+('1'..'9').to_a.shuffle[1]+'","hasTemperature":true,"temperature":"19.'+('1'..'9').to_a.shuffle[1]+'"}'
      c.publish('/pots/soil/fake1', message1)
      sleep(1)
      c.publish('/pots/soil/fake2', message2)
      c.publish('/pots/soil/fake3', message3)
      sleep(2)
   end
end
