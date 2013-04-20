#!/usr/bin/env ruby
#coding: utf-8
#
# People of the Soil - MQTT Listener
# Author: Marcello Seri
# 


require 'rubygems'
require 'mqtt'
require 'json'
require 'httparty'

logfile = 'puts.soil.log'
brokerAddress = 'm2m.eclipse.org'
dataManagerAddress = 'http://soil-sample-api.herokuapp.com/soil_samples'


################################################################################
# Check the validity of the data received 
# and remove the invalid data fields (and the control fields)
def parseAnswer(result, what)
    # control sequence. I.e. what="temperature" -> control="hasTemperature"
    # but what="pH" -> control="hasPH" instead of control="hasPh" (what .capitalize does)
    control = "has" + what.slice(0,1).capitalize + what.slice(1..-1)
    #puts control
    
    if result[control]
        # if there is temperature do nothing
        #puts what + " present!"
    else
        # otherwise delete the eventual temperature entry
        result.delete(what)
        #puts what + " not present!"
    end
    
    #puts result
    
    # and remove the control entry
    result.delete(control)
    
    return result
end
################################################################################

################################################################################
# Actual interface

puts "Start"

# connect to MQTT broker (we use the free m2m.eclipse.org for the tests)
MQTT::Client.connect(brokerAddress,1883) do |client|
    
    puts "Client on"
    
    # subscribe to the topic "People of the Soil - Soil Data" listening for any message
    client.get('/pots/soil/#') do |topic,message|
    
        puts "Got Message"
    
        allRight = nil

        # control JSON integrity
        begin
            # for each message parse the JSON data
            result = JSON.parse(message)
            allRight = true;
        rescue
            # if bad data write it on the log
            File.open(logfile, 'a') { |file| file.write("Broken data received.\n Data: " + message + "\n\n") } 
            allRight = false;
        end
        
        
        if allRight and (!result.has_key?'lat' or !result.has_key?'long' or !result.has_key?'time')
            # Something bad happened, data is broken! Log it and go on with the next data message
            File.open(logfile, 'a') { |file| file.write("Information Needed: we cannot proceed without timestamp and location.\n Data received: " + message + "\n\n") } 
        elsif allRight
        
            # Strip from the result the bad data
            parameters = ["altitude", "pH", "moisture", "temperature"]
            parameters.each {|param| result = parseAnswer(result, param) }
            
            #puts result
            #puts "Data updated!"
        
            # It seems everything is all right, we can proceed sending the data to the messaging system
            
            # We first need to reformat the data
            answer = "{" + result.map{|k,v| "'#{k}' => '#{v}'"}.join(", ") + "}"
            
            #puts answer
            
            begin
                HTTParty.post(dataManagerAddress, {:query => {'soil_sample' => eval(answer)}})
                
                puts "Data sent!"
            rescue 
                File.open(logfile, 'a') { |file| file.write("Error in sending the data.\n\n") } 
            end            
        end
    end
end
################################################################################

