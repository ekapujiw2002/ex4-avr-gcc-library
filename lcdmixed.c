/*
 * lcdmixed.c
 *
 * Created: 8/4/2014 5:18:04 PM
 *  Author: EX4
 */ 

#include <string.h>
#include <stdlib.h>

#include <avr/io.h>
#include <avr/pgmspace.h>

#include "lib/lcd_aligned/lcd_lib.h"

int main(void)
{
	uint16_t xx=0;
	uint8_t data[6];
	lcd_t lcd1 = lcd_struct_default;
	
	lcd1.initialize();
	lcd1.clear(); lcd1.cursor_off();
	lcd1.home();
	lcd1.flash_text((const uint8_t*)PSTR("HELLO WORLD"),0,0);
	
	data[5] = 0;
	for(;;)
	{
		//lcd1.printf(LCD_USE_FLASH,0,1,PSTR("%5u"), xx++);
		//lcd1.flash_text((const uint8_t*)PSTR("     "),0,1);
		utoa(xx++,(char*) data, 10);
		lcd1.position(0,1);
		lcd1.text(data,strlen((const char*)data)); lcd1.text((uint8_t*)"   ",3);
		lcd1.progress_bar(0,2,LCD_PROGRESSBAR_FORWARD,xx>>8,255,20);
	}
}
