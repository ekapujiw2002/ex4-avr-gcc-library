/*
SPI device 74hc165
*/

/*
 * lib
 */
#include <avr/io.h>
#include <util/delay.h>

/*
 * global define
 */
#define PISO_HC165_PORT   	PORTD
#define PISO_HC165_DDR    	DDRD
#define PISO_HC165_PIN    	PIND
#define PISO_HC165_DOUT_POS PIND6      //Data pin (DOUT) pin location
#define PISO_HC165_CLK_POS 	PORTD7      //Shift Clock (CLK) pin location
#define	PISO_HC165_PL_PORT	PORTB
#define	PISO_HC165_PL_DDR	DDRB
#define PISO_HC165_PL_POS 	PORTB0      	//Store Clock (PL) pin location

//Low level macros to change PL lines
#define PISO_PL_High() (PISO_HC165_PL_PORT|=(1<<PISO_HC165_PL_POS))
#define PISO_PL_Low() (PISO_HC165_PL_PORT&=(~(1<<PISO_HC165_PL_POS)))

//Macros CLK
#define PISO_CLK_High()	(PISO_HC165_PORT|=(1<<PISO_HC165_CLK_POS))
#define PISO_CLK_Low()	(PISO_HC165_PORT&=(~(1<<PISO_HC165_CLK_POS)))

//Initialize HC165 System
void PISOHC165Init()
{
	//Make the DOUT=IN, CLK = OUT
	PISO_HC165_DDR&=(~(1<<PISO_HC165_DOUT_POS));
	PISO_HC165_PORT|=(1<<PISO_HC165_DOUT_POS);		//DIN=1
	PISO_HC165_DDR|=(1<<PISO_HC165_CLK_POS);
	PISO_CLK_Low();	//CLK=0

	//PL = OUT, PL=1
	PISO_HC165_PL_DDR|=(1<<PISO_HC165_PL_POS);		//PL=0
	PISO_PL_High();
}

//Sends a clock pulse on SH_CP line
void PISOHC165Pulse()
{
   //Pulse the Shift Clock
	PISO_CLK_High();//HIGH
	PISO_CLK_Low();//LOW
}

//Sends a clock pulse on PL line
void PISOHC165Load()
{
   //Pulse the PL
	PISO_PL_Low();//LOW
   PISO_PL_High();//HIGH
}

/*
Main High level function to read a single byte from
Output shift register 74HC165.

Arguments:
   NONE

Returns:
   byte

Description:
   The byte is serially transfered to 74HC595
   and then latched. The byte is then available on
   output line Q0 to Q7 of the HC595 IC.

*/
uint8_t PISOHC165Read(uint8_t isLoad)
{
   //read each 8 bits serially
   uint8_t tmpd = 0;

   //Order is MSB first
   uint8_t i;

   //do loading input
   if(isLoad==1)
	   PISOHC165Load();

   //get the data
   for(i=0;i<8;i++)
   {
	   //spare 1bit to the left
	   tmpd >>= 1;

	   //send clk
	   if(i==0)
	   {
		   if(isLoad==0)
			   PISOHC165Pulse();
	   }
	   else
		   PISOHC165Pulse();

      //get the data store it from lsb
	   if(bit_is_set(PISO_HC165_PIN,PISO_HC165_DOUT_POS))	//data=1
		   tmpd |= 0x80;
   }
   return tmpd;
}
