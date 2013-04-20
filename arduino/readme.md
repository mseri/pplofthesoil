# Arduino Code for PeopleOfTheSoil

It runs on an AVR with an arduino bootloader.

This project is being created in association with the google/NASA space apps challenge. 

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

Ben Oxley 2013  
[Contact](mailto:bjo1g09@soton.ac.uk) bjo1g09@soton.ac.uk

Copyright (c) 2013, Benjamin James Oxley, http://www.benoxley.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.