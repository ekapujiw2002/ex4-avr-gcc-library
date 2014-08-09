/*
* sim900.h
*
* Created: 7/25/2014 8:20:01 AM
*  Author: EX4
*/

/**
*  @defgroup ex4_sim900 SIM900 GPRS Module
*  @code #include "sim900.h" @endcode
*
*  @brief SIM900 library to handle sms, http request using uart library by Peter Fleury.
*
*  @note Based on Arduino SIM900 library with heavily simplified task
*  @author EX4 ekapujiw2002@gmail.com  http://ex4-tech.id.or.id
*/
/**@{*/
	
#ifndef SIM900_H_
#define SIM900_H_

//lib used
#include <stddef.h>
#include <string.h>
#include <stdlib.h>	//for calloc, atoi
#include <stdio.h>

//avr lib
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <util/delay.h>

//custom lib
#include "../uart/uart.h"

//respons ok / error
/**
@brief	Respon OK string
*/
#define RESPON_OK		"OK"
/**
@brief	Respon ERROR string
*/
#define RESPON_ERROR	"ERROR"

//wait
/**
@brief	Waiting with timeout time
*/
#define SETUP_WAIT_TIMEOUT	0
/**
@brief	Waiting until device attached
*/
#define SETUP_WAIT_INFINITE	1

/**
@brief	Http GET method
*/
#define HTTP_GET	0
/**
@brief	Http POST method
*/
#define HTTP_POST	1

//proto function

/**
* Init uart for modem receive transmit
* @author	EX4
* @version	1.0
* @param	baudrate	UART speed
* @return	-
*/
extern void sim900_init_uart(const uint16_t baudrate);

/**
* Flush all RX buffer
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
extern void uart_flush_buffer();

/**
* Send command to sim900 module and wait for reply at specific timeout
* @author	EX4
* @version	1.0
* @param	send_from_progmem	data from ram or flash (0=ram, 1=flash)
* @param	*aCmd				command to be sent
* @param	*aResponExit		respon string as exit point
* @param	aTimeoutMax			command timeout in usecond
* @param	aLenOut				byte of output data
* @param	*aResponOut			data output pointer
* @return	uint8_t				1=success, 0=fail
*/
extern uint8_t sim900_send_cmd_wait_reply(const uint8_t send_from_progmem, const uint8_t *aCmd, const uint8_t
*aResponExit, const uint32_t aTimeoutMax, const uint8_t aLenOut, uint8_t
*aResponOut);

/**
* Check if modem connected to network or not
* @author	EX4
* @version	1.0
* @param	-
* @return	uint8_t		1=success, 0=fail
*/
extern uint8_t sim900_is_network_registered();

/**
* Initialize modem setup with :
* AT+CMGF=1
* ATE0
* AT+CLIP=1
* AT+CMPS="SM","SM","SM"
* @author	EX4
* @version	1.0
* @param	isWaitingDevice	0=timeout, 1=wait infinite
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_setup(const uint8_t isWaitingDevice);

/**
* Send SMS
* @author	EX4
* @version	1.0
* @param	*aSenderNumber	Destination number
* @param	*aMessage		Message
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_send_sms(const uint8_t *aSenderNumber, const uint8_t *aMessage);

/**
* Call a phone number
* @author	EX4
* @version	1.0
* @param	*aSenderNumber	Destination number
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_call_phone(const uint8_t *aSenderNumber);

/**
* Check if gprs connection is already opened
* @author	EX4
* @version	1.0
* @param	-
* @return	uint8_t			0=closed, 1=opened
*/
extern uint8_t sim900_gprs_is_opened();

/**
* Close gprs connection
* @author	EX4
* @version	1.0
* @param	-
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_gprs_close_connection();

/**
* Start gprs connection with specific bearer profile
* @author	EX4
* @version	1.0
* @param	-
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_gprs_start_connection();

/**
* Save bearer profile and open up gprs connection
* @author	EX4
* @version	1.0
* @param	*apn			APN name
* @param	*username		Username
* @param	*password		Password
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_gprs_open_connection(const uint8_t *apn, const uint8_t *username,
const uint8_t *password);

/**
* Terminate http session
* @author	EX4
* @version	1.0
* @param	-
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_http_terminate();

/**
* Send and/or get data via http POST or GET
* @author	EX4
* @version	1.0
* @param	method			HTTP_GET or HTTP_POST
* @param	*aurl			URL address
* @param	*adata			Data to send
* @param	max_out_len		Maximum number of byte to read if any respon is required
* @param	*arespon_out	Respon buffer. Set it to NULL if you don't want to read any data from server
* @return	uint8_t			0=fail, 1=success
*/
extern uint8_t sim900_http_send_data(const uint8_t method, const uint8_t *aurl, const uint8_t *adata, const  uint8_t max_out_len, uint8_t *arespon_out);

/**
* SIM900 data structure
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
typedef struct sim900_struct
{
	void (*open_port)(const uint16_t baudrate);
	void (*clear_buffer)();
	uint8_t (*send_command)(const uint8_t send_from_progmem, const uint8_t *aCmd, const uint8_t
	*aResponExit, const uint32_t aTimeoutMax, const uint8_t aLenOut, uint8_t
	*aResponOut);
		
	//network and setting
	uint8_t (*is_network_registered)();
	uint8_t (*initialize)(const uint8_t isWaitingDevice);
		
	//sms
	uint8_t (*send_sms)(const uint8_t *aSenderNumber, const uint8_t *aMessage);
		
	//call
	uint8_t (*call_phone)(const uint8_t *aSenderNumber);
		
	//gprs
	uint8_t (*gprs_is_opened)();
	uint8_t (*gprs_close_connection)();
	uint8_t (*gprs_start_connection)();
	uint8_t (*gprs_open_connection)(const uint8_t *apn, const uint8_t *username,
	const uint8_t *password);
		
	//http
	uint8_t (*http_terminate)();
	uint8_t (*http_send_data)(const uint8_t method, const uint8_t *aurl, const uint8_t *adata, const  uint8_t max_out_len, uint8_t *arespon_out);

} sim900_t;

/**
* Default setting
*/
static const sim900_t sim900_struct_default = {
	.call_phone = sim900_call_phone,
	.clear_buffer = uart_flush_buffer,
	.gprs_close_connection = sim900_gprs_close_connection,
	.gprs_is_opened = sim900_gprs_is_opened,
	.gprs_open_connection = sim900_gprs_open_connection,
	.gprs_start_connection = sim900_gprs_start_connection,
	.http_send_data = sim900_http_send_data,
	.http_terminate = sim900_http_terminate,
	.initialize = sim900_setup,
	.is_network_registered = sim900_is_network_registered,
	.open_port = sim900_init_uart,
	.send_command = sim900_send_cmd_wait_reply,
	.send_sms = sim900_send_sms
};

#endif /* SIM900_H_ */
/**@}*/