People of the Soil
============

## Data structure
### Data Sample  
{      "id": "182791",      "time": "13:56:13 20/04/2013",      "lat": "97.03125",      "long": "107.2890",      "hasAltitude":true,      "altitude": "10",      "hasPH":true,      "pH":"7",      "hasMoisture":true,      "moisture":"97",      "hasTemperature":true,      "temperature":"40"  }  

to be sent to
- MQTT Broker: m2m.eclipse.org:1833
- Topic: /pots/soil

## Data acquisition
Requirements:
- ruby 
- mqtt gem
- json gem
- httparyy gem

Register to MQTT Broker: m2m.eclipse.org:1833  
Subscribe to Topic: /pots/soil/#  

