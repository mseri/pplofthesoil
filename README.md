People of the Soil
============

## Data structure
Sample
{    "id": 182791,    "time": "13:56:13 20/04/2013",    "lat": 97.03125,    "long": 107.2890,    "hasAltitude":true,    "altitude": 10,    "hasPH":true,    "pH":7,    "hasMoisture":true,    "moisture":97,    "hasTemperature":true,    "temperature":40}

## Data acquisition
Requirements:
- ruby 
- ruby-mqtt gem
- ruby-json gem

MQTT Broker: m2m.eclipse.org:1833
Topic: /pots/soil/#