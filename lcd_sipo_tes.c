/*
 * lcd_sipo_tes.c
 *
 * Created: 8/9/2014 4:24:38 AM
 *  Author: EX4
 */ 
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "lib/lcd_aligned/lcd_lib.h"

int main(void)
{
	lcd_t lcd1 = lcd_struct_default;
	uint16_t xx=0;
	
	lcd1.initialize();
	lcd1.clear();
	lcd1.cursor_off();
	lcd1.home();
	lcd1.flash_text((const uint8_t*)PSTR("HELLO WORLD"),0,0);	
	lcd1.flash_text((const uint8_t*)PSTR("DEMO LCD SIPO"),0,1);
	//lcd1.flash_text((const uint8_t*)PSTR("74HC595"),0,2);
	//lcd1.flash_text((const uint8_t*)PSTR("BY EX4"),0,3);
	_delay_ms(2000);
	
	//LCDhome();
	for (xx = 0; xx < 10; xx++)
	{
		lcd1.shift_left(1);
		_delay_ms(500);
	}
	
	for (xx = 0; xx < 16; xx++)
	{
		lcd1.shift_right(1);
		_delay_ms(500);
	}
	
	lcd1.clear();
	
	for (;;)
	{
		lcd1.printf(LCD_USE_FLASH,0,0,PSTR("%-5d"),xx);
		lcd1.progress_bar(0,1,LCD_PROGRESSBAR_FORWARD,(uint8_t)xx,255,16);
		xx++;
		if (xx>1000)
		{
			xx=0;
		}
	}
}