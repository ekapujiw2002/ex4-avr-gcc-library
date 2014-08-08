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
#include <stdlib.h>
#include <string.h>

int main(void)
{
	lcd_t lcd1 = lcd_struct_default;
	uint16_t xx=0;
	uint8_t strx[16];
	
	lcd1.initialize();
	lcd1.clear();
	lcd1.cursor_off();
	lcd1.home();
	lcd1.flash_text((const uint8_t*)PSTR("HELLO WORLD"),0,0);
	//LCDsendChar('A');
	
	for (;;)
	{
		//utoa(xx,(char*)strx,10);
		//lcd1.position(0,1);
		//lcd1.text(strx,strlen((char*)strx));
		lcd1.printf(LCD_USE_FLASH,0,1,PSTR("%-5d"),xx);
		lcd1.progress_bar(0,2,LCD_PROGRESSBAR_FORWARD,(uint8_t)xx,255,20);
		xx++;
		if (xx>1000)
		{
			xx=0;
		}
		//_delay_ms(100);
	}
}