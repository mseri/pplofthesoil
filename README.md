People of the Soil
============

For more information on what we want to do you can read:    
- <http://spaceappschallenge.org/challenge/soil-testing-kit>
- <http://spaceappschallenge.org/project/people-of-the-soil/>

## Data structure
### Data Sample  
{      "id": "182791",      "time": "13:56:13 20/04/2013",      "lat": "97.03125",      "long": "107.2890",      "hasAltitude":true,      "altitude": "10",      "hasPH":true,      "pH":"7",      "hasMoisture":true,      "moisture":"97",      "hasTemperature":true,      "temperature":"40"  }  

to be sent to
- MQTT Broker: m2m.eclipse.org:1833
- Topic: /pots/soil

It can be as simple and boring as using <http://mqtt.io/>    
Or you can let your hardware prepare the data and send it using (more or less) any programming language: <http://mqtt.org/software>

## Data acquisition module

Requirements:
- ruby >= 1.8
- mqtt gem
- json gem
- httparty gem
- daemons gem

Register to MQTT Broker: m2m.eclipse.org:1833  
Subscribe to Topic: /pots/soil/#  

