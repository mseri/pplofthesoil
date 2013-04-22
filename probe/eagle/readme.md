# Arduino Code for PeopleOfTheSoil

It runs on an AVR with an arduino bootloader.

This project is being created in association with the google/NASA space apps challenge. 

#Price Breakdown
ATMEGA48A	 	£0.80 
Resistor	 	£0.10 
DS18B20	 		£0.85 
CR2032 Coin Cell	£0.39 
Coin cell holder	£0.20 
PCB manufacture	 	£1.00 
	 	Total	£3.34 

#Roles
This part of the projected aimed to create a proof-of-concept soil testing kit that
could be miniaturised and mass produced. This can then upload recorded soil data, 
taken over a period of several weeks, to a central database via a phone application
or computer interface.

In addition, the aim was to create a PCB schematic and layout to implement this system
realistically and cost such a device.

CAD models were created to aid development and concept presentation.

#Scope
The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.

Project has used the OneWire library to communicate with a DS18B20 temperature 
sensor and a transistor amplified simple moisture sensor.

Moisture is displayed as an estimated percentage volume of water to soil. 
Completely soaked soil will hold up to around 50% water content and so a measurement 
of resistance of pure water is taken as the calibration mark for 50% and the probe 
held in air is taken as the calibration for 0%.

The hardware prototype is a proof of concept, a final device should use a much cheaper
MPU such as an ATMEGA48A-MU 4K memory, 8-Bit MPU. This can be sourced (in bulk) for 
less than 80p per unit.

##Further Work
Implementations of more chemical and pH sensors could be made extremely cheaply and in
bulk by using thick film printing processes. This could be an avenue for further 
development although the technology is still heavily in it's infancy.

## Links
* [Homepage](http://www.benoxley.com/) www.benoxley.com

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="www.benoxley.co.uk">
    <span property="dct:title">Ben Oxley</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">People of the Soil</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="GB" about="www.benoxley.co.uk">
  United Kingdom</span>.
</p>
