# People of the Soil
# Data acquisition and upload script
# v0.1
#
# Written by Stephen Lewis (mail@stephen-lewis.me.uk)
#
# Licensed under the Eclipse Public License v1.0
# http://www.eclipse.org/legal/epl-v10.html
#
# Revision history
# 2013-04-20 14:10		File created		STFL

import serial
import time
import netifaces
#import pygeoip
import io
import string
import mqttpublisher

#port_name = '/dev/ttyUSB0'
#port_name = '/dev/tty.usbmodemfd121'
port_name = '/dev/ttyACM0'

# configure and open serial port for data read
try:
	serial_port = serial.Serial(port_name, baudrate=9600) # assume stopbits=1 bytesize=8 parity='N'
except serial.SerialException:
	print("Unable to open serial port: aborting.\n");
	exit();

if serial_port.isOpen() != True:
	serial_port.open()
	if serial_port.isOpen() != True:
		print("Unable to open serial port: aborting.\n");
		exit()

# read and upload the data: forever
while True:
	# assume format: $<device id>,<temperature>,<moisture>,<pH>\n
	data_list = None
	while data_list == None:
		data = serial_port.readline()
#		print data
		data_list = string.split(data, ',')

	if len(data_list) < 4:
		continue

	device_id = data_list[0]
	temperature = data_list[1]
	moisture = data_list[2]
	pH = data_list[3]

	# fetch timestamp
	timestamp = time.strftime('%X %x %Z')

	#####
 	# Nasty way to find the location
 	#  - maybe replace with cheap GPS in device?

	# fetch IP, and from that GEOIP Data
	#net_dict = netifaces.ifaddresses('wlan0')
#	net_dict = netifaces.ifaddresses('en0')
	#print net_dict
#	ip_dict = net_dict[2]
#	ip_addr = ip_dict[0]["addr"]
	#print ip_addr

	#city_db_path = '/usr/share/GeoIP/GeoIPCity.dat'
#	city_db_path = './GeoIPCity.dat'
#	geoip = pygeoip.GeoIP(city_db_path)
#	geoip_dict = geoip.record_by_addr(ip_addr)
	#print geoip_dict
#	if geoip_dict != None:
#		latitude = geoip_dict["latitude"]
#		longitude = geoip_dict["logitude"]
#	else:
	latitude = '51.522833'
	longitude = '-0.085179'

	# End nasty location finding
	#####

	# build JSON and publish to MQTT
	json = "{\n"
	json += "\"id\" : \"" + device_id + "\",\n"
	json += "\"time\" : \"" + timestamp + "\",\n"
	json += "\"lat\" : \"" + latitude + "\",\n"
	json += "\"long\" : \"" + longitude + "\",\n"
	json += "\"hasAltitude\" : false,\n"
	if pH == 'NULL':
		json += "\"hasPH\" : false,\n"
	else:
		json += "\"hasPH\" : true,\n"
		json += "\"pH\" : \"" + pH + "\",\n"
	if moisture == 'NULL':
		json += "\"hasMoisture\" : false,\n"
	else:
		json += "\"hasMoisture\" : true,\n"
		json += "\"moisture\" : \"" + moisture + "\",\n"
	if temperature == 'NULL':
		json += "\"hasTemperature\" : false,\n"
	else:
		json += "\"hasTemperature\" : true,\n"
		json += "\"temperature\" : \"" + temperature + "\"\n"
	json += "}"

#	print json

	mqttpublisher.sendSensorData(json)

# EOF
