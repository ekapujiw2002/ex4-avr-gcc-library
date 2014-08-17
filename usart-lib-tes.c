/*
* usart_lib_tes.c
*
* Created: 8/17/2014 7:13:53 PM
*  Author: EX4
*/

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

#include "lib/usart_ex4/usart_lib.h"
#include "lib/i2c_master/I2C_master.h"

#define i2c_dev_addr 0x20

/**
* i2c multi read
* @author
* @version
* @param
* @return
*/
void i2c_read(const uint8_t i2c_device_addr,const uint8_t i2c_register_addr, uint8_t *i2c_data_buffer,const uint8_t i2c_data_len)
{
	uint8_t i;
	
	I2C_start(i2c_device_addr);
	I2C_write(i2c_register_addr);
	I2C_start(i2c_device_addr+I2C_READ);
	for (i = 0; i < i2c_data_len; i++)
	{
		*(i2c_data_buffer++) = (i<(i2c_data_len-1)) ? I2C_read_ack():I2C_read_nack();
	}
	I2C_stop();
}

void i2c_write(const uint8_t i2c_device_addr,const uint8_t i2c_register_addr, uint8_t *i2c_data_buffer,const uint8_t i2c_data_len)
{
	uint8_t i;
	
	I2C_start(i2c_device_addr);
	I2C_write(i2c_register_addr);
	for (i = 0; i < i2c_data_len; i++)
	{
		I2C_write(*(i2c_data_buffer++));
	}
	I2C_stop();
}

int main(void)
{
	uint8_t xx = 0, yy = 0, i2c_buffer[32];
	
	USART_InitFast(BAUD_57600, COM_CH0);
	USART_SetStdin();
	USART_SetStdout();
	
	//printf_P(PSTR("HELLO WORLD\rEnter a number :"));
	//scanf_P(PSTR("%u"), &xx);
	//printf_P(PSTR("You enter : %u\r"), xx);
	
	I2C_init();
	
	sei();
	
	_delay_ms(500);
	//update pwm all to 50% dc
	i2c_read(i2c_dev_addr,0x0c,&i2c_buffer[0],12);
	
	i2c_buffer[0] = 1;
	i2c_buffer[2] = i2c_buffer[3] = i2c_buffer[10] = i2c_buffer[11] = 128;
	i2c_buffer[5] = i2c_buffer[7] = 216;
	i2c_buffer[6] = i2c_buffer[8] = 0;
	i2c_write(i2c_dev_addr,0x0d,&i2c_buffer[1],11);
	i2c_write(i2c_dev_addr,0x0c,&i2c_buffer[0],1);
	
	i2c_read(i2c_dev_addr,0x0c,&i2c_buffer[0],12);
	printf_P(PSTR("%02x %02x %02x\r"), i2c_buffer[1], i2c_buffer[2], i2c_buffer[3]);
	printf_P(PSTR("%02x %02x %02x\r"), i2c_buffer[4], i2c_buffer[5], i2c_buffer[7]);
	printf_P(PSTR("%02x %02x %02x\r"), i2c_buffer[9], i2c_buffer[10], i2c_buffer[11]);
	
	for (;;)
	{
		//read i2c dev DI
		i2c_read(i2c_dev_addr,0x02,&i2c_buffer[0],1);
		xx = i2c_buffer[0];
		printf_P(PSTR("%02x\r"), i2c_buffer[0]);
		i2c_write(i2c_dev_addr,0x03,&i2c_buffer[0],1);
		
		//read i2c adc
		i2c_read(i2c_dev_addr,0x0a,&i2c_buffer[0],2);
		printf_P(PSTR("adc = %4d\r"), i2c_buffer[0] + (i2c_buffer[1]<<8));
		
		//update pwm
		if (xx!=yy)
		{
			yy=xx;
			i2c_read(i2c_dev_addr,0x0c,&i2c_buffer[0],12);
			i2c_buffer[0] = 1;
			i2c_buffer[1] = i2c_buffer[4] = i2c_buffer[9]  = yy;
			i2c_write(i2c_dev_addr,0x0d,&i2c_buffer[1],11);
			i2c_write(i2c_dev_addr,0x0c,&i2c_buffer[0],1);
		}
		
		_delay_ms(500);
	}
}