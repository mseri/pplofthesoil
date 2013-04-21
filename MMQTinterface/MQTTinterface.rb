#!/usr/bin/env ruby
#coding: utf-8
#
# People of the Soil - MQTT Listener
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

require 'rubygems'
require 'mqtt'
require 'json'
require 'httparty'

################################################################################
# Check the validity of the data received 
# and remove the invalid data fields (and the control fields)
def parseAnswer(result, what, debugLevel)
    begin
        # control sequence. I.e. what="temperature" -> control="hasTemperature"
        # but what="pH" -> control="hasPH" instead of control="hasPh"
        control = "has" + what.slice(0,1).capitalize + what.slice(1..-1)
        #puts control
    
        if result[control]
            # if there is something do nothing unless it is null, 
            # in such case translate it for the DB service
            if result[what]=="NULL"
                result[what]="nil"
            end
            puts what + " present!"  if debugLevel >= 2
        else
            # otherwise delete the eventual temperature entry
            result[what] = "nil"
            puts what + " not present!"  if debugLevel >= 2
        end
    
        #puts result 
    
        # and remove the control entry
        result.delete(control)
    rescue
        # if something goes wrong we just log it and go on with new data...
        File.open(logFile, 'a') { |file| file.write("Error in stripping the data.\n\n") }
        result = nil
    end
    
    return result
end

def elaborateMQTTMessage(message, dataManagerAddress, logFile, debugLevel)
            # control JSON integrity
            allRight = nil
            
            begin
                # JSON is sensitive to carriage returns, newlines and other small details
                # we try to prevent these error stripping the bad characters before
                # doing the real parsing.
                message = message.gsub(/\n/,'')
                message = message.gsub(/\r/,'')
                message = message.gsub(' : ',':')
                
                puts message if debugLevel >=2
                
                # for each message parse the JSON data
                result = JSON.parse(message)
                allRight = true;
            rescue
                # if bad data write it on the log
                File.open(logFile, 'a') { |file| file.write("Broken data received.\n Data: " + message + "\n\n") } 
                allRight = false;
                
                puts "Pretty bad data!" if debugLevel >= 1
            end
        
        
            if allRight and (!result.has_key?'lat' or !result.has_key?'long' or !result.has_key?'time' or !result.has_key?'id')
                # Something bad happened, data is broken! Log it and go on with the next data message
                File.open(logFile, 'a') { |file| file.write("Information Needed: we cannot proceed without timestamp and location.\n Data received: " + message + "\n\n") }
                puts "Bad data!" if debugLevel >= 1
                
            elsif allRight and (result["lat"] == "NULL" or result["long"] == "NULL" or result["time"] == "NULL" or result["id"] == "NULL")
                # Something bad happened, data is broken! Log it and go on with the next data message
                File.open(logFile, 'a') { |file| file.write("Information Needed: we cannot proceed without timestamp and location.\n Data received: " + message + "\n\n") }
                puts "NULL data!" if debugLevel >= 1
            elsif allRight
                
                # Rename 'id' field to make it compatible with the server
                result["device_id"] = result["id"]
                result.delete("id")
                
                # Add "device probe" to make server happy
                result["device"] = "probe"
            
                # Strip from the result the bad data
                parameters = ["altitude", "pH", "moisture", "temperature"]
                parameters.each {|param| result = parseAnswer(result, param, debugLevel)}
                
                if result
                    # puts result if debugLevel >= 2
                    puts "Data parsed!"  if debugLevel >= 2
        
                    # It seems everything is all right, we can proceed sending the data to the messaging system
            
                    # We first need to reformat the data
                    answer = "{" + result.map{|k,v| "'#{k}' => '#{v}'"}.join(", ") + "}"
                
                    puts answer if debugLevel >= 2
            
                    begin
                        HTTParty.post(dataManagerAddress, {:query => {'soil_sample' => eval(answer)}})
                
                        puts "Data sent!" if debugLevel >= 1
                    rescue 
                        File.open(logFile, 'a') { |file| file.write("Error in sending the data.\n\n") }
                        puts "Something wrong with the data manager!" if debugLevel >= 1
                    end
                end
            end
end


################################################################################
# Actual interface
#
def listenToMQTTForSoilData(brokerAddress,brokerPort,subscribedTopic,dataManagerAddress,logFile,debugLevel = 1)
        
    puts "Start" if debugLevel >= 1

    # connect to MQTT broker (we use the free m2m.eclipse.org for the tests)
    MQTT::Client.connect(brokerAddress,brokerPort) do |client|
    
        puts "Client on" if debugLevel >= 1
    
        # subscribe to the topic "People of the Soil - Soil Data" listening for any message
        client.get(subscribedTopic) do |topic,message|
    
            puts "Got Message" if debugLevel >= 1
    
            elaborateMQTTMessage(message, dataManagerAddress, logFile, debugLevel)

            
        end
    end
end
################################################################################

################################################################################
# Do you want to run it from CL? Here we go!
#
if __FILE__ == $0
    
    # script running from command line
    puts "Please run it from command line with 'ruby CLIrun.rb'"
    
end
