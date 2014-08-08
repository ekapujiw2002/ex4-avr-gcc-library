/*
 * my_lib_test.c
 *
 * Created: 7/5/2014 5:44:29 AM
 *  Author: EX4
 */ 

//lib used
#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>
//#include "lib/lcd_mixed.h"
#include "lib/usart_lib.h"

//const uint8_t bell[] PROGMEM = {0x04, 0x0E, 0x0E, 0x0E, 0x1F, 0x00, 0x04, 0x00};

int main(void)
{
	uint8_t x=0;
	
	//init usart
	USART_InitFast(BAUD_38400, COM_CH0);
	USART_SetStdin();
	USART_SetStdout();
	
	//LCDinit();	
	//LCDclr();
	//LCDcursorOFF();
	//
	//LCDdefinechar(bell,6);
	//LCDGotoXY(15,0);
	//LCDsendChar(6);
	
    while(1)
    {
		//LCDhome();
		//fprintf(&LCDInputOutputStream,"%3d", x);
		//
		//LCDGotoXY(0,1);
		//LCDprogressBar(x,255,16);
		//
		//x++;
		//_delay_ms(10);
    }
}