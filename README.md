# People of the Soil

During the Space Apps Challenge 2013, at the Google Campus in London, we have developed **Soil**: an extremely cheap and easy to use system to collect and manage soil data.

We kept in mind that not all the world is as lucky as us and there are plenty of places where internet is slow or completely absent and where there is much less money around. With **Soil** we created an open system that includes:

- an extremely cheap (~3£) digital soil testing kit to collect data, and eventually send it
- a light protocol to send the data using web, apps or even SMS and collect it on a centralised database
- an API to disseminate information via SMS or web
- a wonderful and light web application that can run on old and recent phones and gives access to the data with a simple and nice interface.

Look what we did going to the [Git Hub page](https://github.com/mseri/pplofthesoil), looking for our [hashtag #pplofthesoil](http://bit.ly/124FU89) on Twitter or reading our ["storified" weekend story](http://bit.ly/ZIbJ3x)

And with our small collaboration with solsola we are ready to fly on the space and collect extra terrestrial soil data!

* * * * * * *

For more information on what we want to do you can read:    
- [Soil Testing Kit Challenge](http://spaceappschallenge.org/challenge/soil-testing-kit)
- [People of the Soil -- Project Page](http://spaceappschallenge.org/project/people-of-the-soil/)

* * * * * * * 

The Git repository contains:

- The **presentation** of our work: *SOILPres-v3.pdf*
- The full implementation of the **probe** (hardware and software) and the **PCB** schematic to build a cheap and effective probe: *probe* folder
- The interface to the **MQTT** service that translates the data and sends it to the DB: *MQTTinterface* folder
- The **DB and SMS** service (hosted on another Git repo): *text-message-and-database-api* folder
- The **mobile app** to have access to the data: *mobileapp* folder

* * * * * * * * * *    
* * * * * * * * * *    

# Something more technical for us and potential collaborators

## Data structure

Data readings are of the form  

{      "id": "182791",      "time": "13:56:13 20/04/2013",      "lat": "97.03125",      "long": "107.2890",      "hasAltitude":true,      "altitude": "10",      "hasPH":true,      "pH":"7",      "hasMoisture":true,      "moisture":"97",      "hasTemperature":true,      "temperature":"40"  }  

and must be sent to
- MQTT Broker: m2m.eclipse.org:1833
- Topic: /pots/soil

id, time, lat, long MUST be present and not NULL, otherwise the data is sent directly to /dev/null

It can be done as simple and boring as using <http://mqtt.io/>    
Or you can let your hardware prepare the data and send it using (more or less) any programming language: <http://mqtt.org/software>

