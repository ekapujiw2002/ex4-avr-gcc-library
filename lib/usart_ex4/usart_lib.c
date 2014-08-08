/*
 * usart_lib_ex4.c
 *
 * Created: 6/20/2012 6:03:50 AM
 *  Author: EX4
 */ 

//lib
#include "usart_lib.h"

//file var
FILE USARTInputOutputStream = FDEV_SETUP_STREAM(USART_OutputStream,USART_InputStream,_FDEV_SETUP_RW);

//usart init custom way
void USART_Init(
const uint16_t aBaudRate,
const uint8_t aChannel,
const uint8_t aParity,
const uint8_t aStopBits,
const uint8_t aDataBits)
{
	uint16_t brv = UBRR_Value(aBaudRate);
	
	/* set baudrate */
	//for 1 channel usart
	#ifdef UBRRH
	//set ubrr value
	UBRRH = brv>>8;
	UBRRL = brv;
	
	/* on RX TX */
	UCSRB |= _BV(RXEN) | _BV(TXEN);
	
	/* set parity, stop bit, data bit format */
	UCSRC |= _BV(URSEL) | (aParity<<4) | (aStopBits<<3) | (aDataBits<<1);
	#endif
	
	#ifdef UBRR0H
	if(aChannel==0)
	{
		//set ubrr value
		UBRR0H = brv>>8;
		UBRR0L = brv;
		
		/* on RX TX */
		UCSR0B |= _BV(RXEN0) | _BV(TXEN0);
		
		/* set parity, stop bit, data bit format */
		UCSR0C |= (aParity<<4) | (aStopBits<<3) | (aDataBits<<1);
	}
	#endif
	
	#ifdef UBRR1H
	if(aChannel==1)
	{
		//set ubrr value
		UBRR1H = brv>>8;
		UBRR1L = brv;
		
		/* on RX TX */
		UCSR1B |= _BV(RXEN1) | _BV(TXEN1);
		
		/* set parity, stop bit, data bit format */
		UCSR1C |= (aParity<<4) | (aStopBits<<3) | (aDataBits<<1);
	}
	#endif
}

//usart init fast way : 8-N-1
void USART_InitFast(
const uint16_t aBaudRate,
const uint8_t aChannel)
{
	uint16_t brv = UBRR_Value(aBaudRate);
	
	/* set baudrate */
	//for 1 channel usart
	#ifdef UBRRH
	//set ubrr value
	UBRRH = brv>>8;
	UBRRL = brv;
	
	/* on RX TX */
	UCSRB |= _BV(RXEN) | _BV(TXEN);
	
	/* set parity, stop bit, data bit format */
	UCSRC |= _BV(URSEL) | (PARITY_NONE<<4) | (STOP_BIT_1<<3) | (DATA_BIT_8<<1);
	#endif
	
	#ifdef UBRR0H
	if(aChannel==0)
	{
		//set ubrr value
		UBRR0H = brv>>8;
		UBRR0L = brv;
		
		/* on RX TX */
		UCSR0B |= _BV(RXEN0) | _BV(TXEN0);
		
		/* set parity, stop bit, data bit format */
		UCSR0C |= (PARITY_NONE<<4) | (STOP_BIT_1<<3) | (DATA_BIT_8<<1);
	}
	#endif
	
	#ifdef UBRR1H
	if(aChannel==1)
	{
		//set ubrr value
		UBRR1H = brv>>8;
		UBRR1L = brv;
		
		/* on RX TX */
		UCSR1B |= _BV(RXEN1) | _BV(TXEN1);
		
		/* set parity, stop bit, data bit format */
		UCSR1C |= (PARITY_NONE<<4) | (STOP_BIT_1<<3) | (DATA_BIT_8<<1);
	}
	#endif
}

/*
enable isr for usart
make your own isr handle on the main program
for easy command handling of your program
*/
void USART_Enable_ISR(const uint8_t ISR_RX,const uint8_t ISR_TX)
{
	#ifdef UCSRB
	UCSRB |= (ISR_RX<<RXCIE) | (ISR_TX<<TXCIE);
	#endif
	
	#ifdef UCSR0B
	UCSR0B |= (ISR_RX<<RXCIE0) | (ISR_TX<<TXCIE0);
	#endif
	
	#ifdef UCSR1B
	UCSR1B |= (ISR_RX<<RXCIE1) | (ISR_TX<<TXCIE1);
	#endif
	
	if (ISR_TX | ISR_RX)
	{
		sei();
	}
}

/*
receive 1 byte data from usart
*/
uint8_t USART_Receive(const uint8_t aChannel)
{
	uint8_t tmp=0;
	
	/* wait data to be received */
	#ifdef UCSRA
	loop_until_bit_is_set(UCSRA, RXC);
	#endif
	
	#ifdef UCSR0A
	if(aChannel==0)
	loop_until_bit_is_set(UCSR0A, RXC0);
	#endif
	
	#ifdef UCSR1A
	if(aChannel==1)
	loop_until_bit_is_set(UCSR1A, RXC1);
	#endif
	
	
	/* return data */
	#ifdef UDR
	tmp = UDR;
	#endif

	#ifdef UDR0
	if(aChannel==0)
	tmp = UDR0;
	#endif
	
	#ifdef UDR1
	if(aChannel==1)
	tmp = UDR1;
	#endif
	
	return tmp;
}

/*
receive 1 byte data from usart with timeout
*/
uint8_t USART_Receive_Timeout(const uint8_t aChannel, const uint32_t aTimeout)
{
	uint8_t tmp=0;
	uint32_t cntx=0;
	
	/* wait data to be received */
	#ifdef UCSRA
	//loop_until_bit_is_set(UCSRA, RXC);
	while (bit_is_clear(UCSRA,RXC) && (cntx++<aTimeout))
	{
		_delay_us(1);
	}
	#endif
	
	#ifdef UCSR0A
	if(aChannel==0)
	//loop_until_bit_is_set(UCSR0A, RXC0);
	while (bit_is_clear(UCSR0A,RXC0) && (cntx++<aTimeout))
	{
		_delay_us(1);
	}
	#endif
	
	#ifdef UCSR1A
	if(aChannel==1)
	//loop_until_bit_is_set(UCSR1A, RXC1);
	while (bit_is_clear(UCSR1A,RXC1) && (cntx++<aTimeout))
	{
		_delay_us(1);
	}
	#endif
	
	//is timeout
	if (cntx>=aTimeout)
	{
		return 0;
	}
	
	/* return data */
	#ifdef UDR
	tmp = UDR;
	#endif

	#ifdef UDR0
	if(aChannel==0)
	tmp = UDR0;
	#endif
	
	#ifdef UDR1
	if(aChannel==1)
	tmp = UDR1;
	#endif
	
	return tmp;
}

/*
transmit 1 byte data to usart
*/
void USART_Transmit(uint8_t aData , const uint8_t aChannel)
{
	/* wait until empty */
	#ifdef UCSRA
	loop_until_bit_is_set(UCSRA, UDRE);
	#endif
	
	#ifdef UCSR0A
	if(aChannel==0)
	loop_until_bit_is_set(UCSR0A, UDRE0);
	#endif
	
	#ifdef UCSR1A
	if(aChannel==1)
	loop_until_bit_is_set(UCSR1A, UDRE1);
	#endif
	
	/* send data */
	#ifdef UDR
	UDR = aData;
	#endif

	#ifdef UDR0
	if(aChannel==0)
	UDR0 = aData;
	#endif
	
	#ifdef UDR1
	if(aChannel==1)
	UDR1 = aData;
	#endif
}

/*
transmit string
*/
void USART_Transmit_String(uint8_t* str, const uint8_t aChannel)
{
	while(*str)
	USART_Transmit(*str++,aChannel);
}

/*
receive array of char from usart
exit on CR on max buff length
*/
void USART_Receive_String(uint8_t* RXBuffOut,const uint8_t max_len, const uint8_t aChannel)
{
	uint8_t len_data=0;
	//while(*RXBuffOut)
	while(len_data<max_len)
	{
		*RXBuffOut = USART_Receive(aChannel);
		if(*RXBuffOut==CRX)
		{
			*RXBuffOut = '\0';
			break;
		}
		RXBuffOut++;
		len_data++;
	}
}

//send data from stream version
int USART_OutputStream(char ch, FILE *stream)
{
	USART_Transmit((uint8_t) ch, 0);
	return 0;
}

//get data from stream version
char USART_InputStream(FILE *stream)
{
	return (char) USART_Receive(0);
}

//usart set as stdin
void USART_SetStdin()
{
	stdin = &USARTInputOutputStream;
}

//usart set as stdout
void USART_SetStdout()
{
	stdout = &USARTInputOutputStream;
}