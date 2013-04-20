#!/usr/bin/env ruby

require 'rubygems'
require 'mqtt'
require 'json'
require 'uri'
require 'net/http'

puts "Start"

#connect to MQTT broker
MQTT::Client.connect('m2m.eclipse.org',1883) do |client|
    
    puts "Client on"
    
    #subscribe to the topic "People of the Soil - Soil Data" listening for any message
    client.get('/pots/soil/#') do |topic,message|
    
        puts "Got Message"
    
        allRight = nil

        #control JSON integrity
        begin
            #for each message parse the JSON data
            result = JSON.parse(message)
            allRight = true;
            
            puts result
        rescue
            #if bad data write it on the log
            File.open('puts.soil.log', 'w') { |file| file.write("Broken data received.\n Data: " + message) } 
            allRight = false;
        end
        
        
        if allRight and (!result.has_key?'lat' or !result.has_key?'lon' or !result.has_key?'time')
            #something bad happened, log it and go on with the next data message
            #raise 'Information Needed: we cannot proceed without timestamp and location.' 
            File.open('puts.soil.log', 'w') { |file| file.write("Information Needed: we cannot proceed without timestamp and location.\n Data received: "+ message) } 
        elsif allRight
        
            if result['hasPH']
        
        
        
            #it seems everything is all right, we can proceed sending the data to the messaging system

            uri = URI.parse("http://soil-sample-api.herokuapp.com/soil_samples")
            http = Net::HTTP.new(uri.host, uri.port)
            req = Net::HTTP::Post.new(uri.path, result)
            
            begin
                resp = http.request(req)
                puts resp
            rescue 
                File.open('puts.soil.log', 'w') { |file| file.write("Error in sending the data.") } 
            end            
        end
    end
end


