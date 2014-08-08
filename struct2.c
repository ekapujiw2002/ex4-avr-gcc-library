/*
 * struct2.c
 *
 * Created: 7/31/2014 4:30:39 AM
 *  Author: EX4
 */ 

#include <stdlib.h>
#include <stddef.h>

#include <avr/io.h>
#include <util/delay.h>

//led struct
//static const volatile uint8_t *led_port;
typedef struct led_s
{
	volatile uint8_t *led_port;
	
	void (*toggle)(struct led_s *led_obj, const uint8_t pin_number);
} led_t;

led_t *new_led(volatile uint8_t *new_led_port);
void destroy_led(led_t *led_obj);

static void port_init(led_t *led_obj)
{
	volatile uint8_t *led_ddr = led_obj->led_port;
	led_obj->led_port = 0;
	*(--led_ddr)= 0xff;
	led_ddr++;
}

static void led_toggle(led_t *led_obj, const uint8_t pin_number)
{
	uint8_t lv = *(led_obj->led_port);
	volatile uint8_t *px = led_obj->led_port;
	PORTC = lv;
	*px =lv ^ _BV(pin_number);
	//PORTB ^= _BV(pin_number);
}

led_t *new_led(volatile uint8_t *new_led_port)
{
	led_t *ledx = (led_t*) malloc(sizeof(led_t));
	
	ledx->led_port = new_led_port;
	ledx->toggle = led_toggle;
	
	port_init(ledx);
	
	return ledx;
}

void destroy_led(led_t *led_obj)
{
	free(led_obj);
}

int main(void)
{
	led_t *led1 = new_led(&PORTB);
	
	DDRC = 0xff;
	PORTC = 0;
	
	for (;;)
	{
		led1->toggle(led1,PB0);
		_delay_ms(250);
	}
}
