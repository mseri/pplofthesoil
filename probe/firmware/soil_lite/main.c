/*
Project Soil V1.1 Firmware V0.1

This program is made for Project Soil proceeding from the 
Google Space Apps Challenge. Please find more information at:
http://spaceappschallenge.org/project/people-of-the-soil/
or
https://github.com/mseri/pplofthesoil

Ben Oxley 2013

LEDs are on Pins 22(PC7),23(PC6),25(PC5),26(PC4) and 5(PC2)
*/

#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <avr/wdt.h>

#define output_low(port,pin) port &= ~(1<<pin)
#define output_high(port,pin) port |= (1<<pin)
#define set_input(portdir,pin) portdir &= ~(1<<pin)
#define set_output(portdir,pin) portdir |= (1<<pin)

void delay_ms(uint8_t ms) {
	uint16_t delay_count = F_CPU / 17500;
	volatile uint16_t i;

	while (ms != 0) {
		for (i=0; i != delay_count; i++);
			ms--;
	}
}

int main(void)
{
	DDRC |= 0xFF;
	while(true){
	  output_high(PORTC, PC7);
      _delay_ms(500);
      output_low(PORTC, PC7);
      _delay_ms(500);
	}
	return 0;
}