/*
 * usart_lib_ex4.h
 *
 * Created: 6/20/2012 6:02:13 AM
 *  Author: EX4
 */ 


#ifndef USART_LIB_H_
#define USART_LIB_H_

//lib used
#include <stdio.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

//usart macro
#define UBRR_Value(aBaud) ((F_CPU/16/aBaud)-1)

//baud value
#define BAUD_1200	1200UL
#define BAUD_2400	2400UL
#define BAUD_4800	4800UL
#define BAUD_9600	9600UL
#define BAUD_19200	19200UL
#define BAUD_38400	38400UL
#define BAUD_56000	56000UL
#define BAUD_57600	57600UL
#define BAUD_115200	115200UL

//channel com
#define COM_CH0	0
#define COM_CH1	1
#define COM_CH2	2
#define COM_CH3	3

//parity bit
#define PARITY_NONE	0
#define PARITY_EVEN	2
#define PARITY_ODD	3

//stop bit
#define STOP_BIT_1	0
#define STOP_BIT_2	1

//data bit
#define DATA_BIT_5	0
#define DATA_BIT_6	1
#define DATA_BIT_7	2
#define DATA_BIT_8	3

//character util
#define TABX	0x09
#define CRX		0x0D
#define LFX		0x0A

//usart file stream. use it with fprintf or any other io stream
//extern FILE USARTInputOutputStream;

//proto
void USART_Init(const uint16_t aBaudRate,const uint8_t aChannel,const uint8_t aParity,const uint8_t aStopBits,const uint8_t aDataBits);
void USART_InitFast(const uint16_t aBaudRate, const uint8_t aChannel);
void USART_Enable_ISR(const uint8_t ISR_RX,const uint8_t ISR_TX);
uint8_t USART_Receive( uint8_t aChannel);
uint8_t USART_Receive_Timeout(const uint8_t aChannel, const uint32_t aTimeout);
void USART_Transmit(uint8_t aData , const uint8_t aChannel);
void USART_Transmit_String( uint8_t* str, const  uint8_t aChannel);
void USART_Receive_String(uint8_t* RXBuffOut,const uint8_t max_len, const  uint8_t aChannel);

//stream version
int USART_OutputStream(char ch, FILE *stream);
char USART_InputStream(FILE *stream);

//usart set as stdin
void USART_SetStdin();
//usart set as stdout
void USART_SetStdout();

#endif /* USART_LIB_H_ */