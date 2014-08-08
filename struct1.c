/*
* struct1.c
*
* Created: 7/30/2014 5:33:17 AM
*  Author: EX4
*/
#include <stdio.h>

#include <avr/io.h>
#include <util/delay.h>
#include <avr/pgmspace.h>

#include "lib/adc/adc.h"
//#include "lib/lcd_aligned/lcd_lib.h"
#include "lib/sim900/sim900.h"

/*
//proto func / void
uint8_t mul_imp(const uint8_t a, const uint8_t b);

//structure
struct lcd_struct
{
uint8_t xp, yp;
uint8_t (*mulx)(const uint8_t, const uint8_t);
} lcd_struct_default = {0,0,mul_imp};

//type alias
typedef struct lcd_struct lcd_t;

//function
uint8_t mul_imp(const uint8_t a, const uint8_t b)
{
return a*b;
}

//port io as parameter
uint8_t switch_read(volatile uint8_t *pin_name, const uint8_t pin_number)
{
return *pin_name;
}
*/

void setup()
{
}

//man program
int main(void)
{
	//var
	//lcd_t lcd1 = lcd_struct_default;
	adc_t adc1 = adc_struct_default;
	sim900_t modem1 = sim900_struct_default;
	uint16_t x0=0;
	
	//lcd1.initialize();
	//lcd1.flash_text((const uint8_t*)PSTR("Hello ^_^"), 0, 0);
	
	adc1.init(ADC_VREF_AVCC, ADC_DATA_10BIT, ADC_PSC128);
	
	modem1.open_port(57600);
	modem1.initialize(SETUP_WAIT_INFINITE);
	modem1.send_sms((const uint8_t*)"087897781037",(const uint8_t*)"halo sayang");
	
	//main loop
	for (;;)
	{
		x0 = adc1.read(ADC_CH0);
		//lcd1.printf(LCD_USE_FLASH, 9,0,PSTR("%4d"),x0);
		//lcd1.progress_bar(0,1,LCD_PROGRESSBAR_BACKWARD, x0>>2,255,20);
		//lcd1.progress_bar(20,1,LCD_PROGRESSBAR_FORWARD, x0>>2,255,20);
		//lcd1.printf(LCD_USE_FLASH,0,3,PSTR("[V+] [V-] [I+] [I-]"));
	}
}