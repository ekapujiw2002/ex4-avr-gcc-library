/*
* lcd_lib.c
*
* Created: 9/5/2012 10:46:16 AM
*  Author: EX4
*/

//lib
#include "lcd_lib.h"

//static func void
//toggle enable pin
static void LCDtoggleEn();
//wait until bf=0
static void LCDwaitUntilNotBusy();

#if LCD_MIXED_PIN == 1
//setup lcd pin in mized mode
static void lcd_pin_mixed_setup();
#endif

#if LCD_USE_FILESTREAM == 1
//send stream char
static int LCDsendCharStream(char ch, FILE *stream);
//stream
static FILE LCDInputOutputStream = FDEV_SETUP_STREAM(LCDsendCharStream,NULL,_FDEV_SETUP_WRITE);
#endif

//const
const uint8_t LcdCustomChar[] PROGMEM=//define 8 custom LCD chars
{
	0x00, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x1F, 0x00, // 0. 0/5 full progress block
	0x00, 0x1F, 0x10, 0x10, 0x10, 0x10, 0x1F, 0x00, // 1. 1/5 full progress block
	0x00, 0x1F, 0x18, 0x18, 0x18, 0x18, 0x1F, 0x00, // 2. 2/5 full progress block
	0x00, 0x1F, 0x1C, 0x1C, 0x1C, 0x1C, 0x1F, 0x00, // 3. 3/5 full progress block
	0x00, 0x1F, 0x1E, 0x1E, 0x1E, 0x1E, 0x1F, 0x00, // 4. 4/5 full progress block
	0x00, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x00, // 5. 5/5 full progress block
	0x03, 0x07, 0x0F, 0x1F, 0x0F, 0x07, 0x03, 0x00, // 6. rewind arrow
	0x18, 0x1C, 0x1E, 0x1F, 0x1E, 0x1C, 0x18, 0x00  // 7. fast-forward arrow
};

#if LCD_MIXED_PIN == 1
//setup lcd pin
static void lcd_pin_mixed_setup()
{
	//setup lcd pin
	LCD_RS_DDR |= _BV(LCD_RS_BIT);
	LCD_RS_PORT &= ~(_BV(LCD_RS_BIT));
	
	#if (USE_BUSY_FLAG == 1)
	LCD_RW_DDR |= _BV(LCD_RW_BIT);
	LCD_RW_PORT &= ~(_BV(LCD_RW_BIT));
	#endif
	
	LCD_EN_DDR |= _BV(LCD_EN_BIT);
	LCD_EN_PORT &= ~(_BV(LCD_EN_BIT));
	
	//data pin lcd
	LCD_D4_DDR |= _BV(LCD_D4_BIT);
	LCD_D5_DDR |= _BV(LCD_D5_BIT);
	LCD_D6_DDR |= _BV(LCD_D6_BIT);
	LCD_D7_DDR |= _BV(LCD_D7_BIT);

	LCD_D4_PORT &= ~(_BV(LCD_D4_BIT));
	LCD_D5_PORT &= ~(_BV(LCD_D5_BIT));
	LCD_D6_PORT &= ~(_BV(LCD_D6_BIT));
	LCD_D7_PORT &= ~(_BV(LCD_D7_BIT));
}
#endif

//lcd init
void LCDinit()
{
	//init lcd
	_delay_ms(50);
	
	#if LCD_MIXED_PIN == 0
		LCD_DDR=255;
		LCD_PORT=0x30;	//DB4 = DB5 = 1, RS = RW = 0
		LCDtoggleEn();
		_delay_ms(10);
		
		LCD_PORT=0x30;	//DB4 = DB5 = 1, RS = RW = 0
		LCDtoggleEn();
		_delay_ms(5);
		
		LCD_PORT=0x30;	//DB4 = DB5 = 1, RS = RW = 0
		LCDtoggleEn();
		_delay_ms(5);
		
		LCD_PORT=0x20;	//DB5 = 1, RS = RW = 0
		LCDtoggleEn();
		_delay_ms(5);
	#else
		//setup lcd pin
		lcd_pin_mixed_setup();
		
		//init lcd
		_delay_ms(50);
		LCD_RS_PORT &= ~(_BV(LCD_RS_BIT));
		LCD_EN_PORT &= ~(_BV(LCD_EN_BIT));
		LCD_D4_PORT |= _BV(LCD_D4_BIT);
		LCD_D5_PORT |= _BV(LCD_D5_BIT);
		LCDtoggleEn();
		_delay_ms(10);
		
		//LCD_PORT=0x30;	//DB4 = DB5 = 1, RS = RW = 0
		LCDtoggleEn();
		_delay_ms(5);
		
		//LCD_PORT=0x30;	//DB4 = DB5 = 1, RS = RW = 0
		LCDtoggleEn();
		_delay_ms(5);
		
		//LCD_PORT=0x20;	//DB5 = 1, RS = RW = 0
		LCD_D4_PORT &= ~(_BV(LCD_D4_BIT));
		LCDtoggleEn();
		_delay_ms(5);
	#endif
	
	//set setting
	LCDsendCommand(0x28);	//4bit 2line 5x7font
	LCDsendCommand(0x0c);	//display on cursor off
	LCDsendCommand(0x06);	//auto inc display shift off
	LCDsendCommand(0x80);	//cursor home
	
	//init 8 custom chars
	LCDDefineProgressBarChar();
}

//init 8 custom char
void LCDDefineProgressBarChar()
{
	uint8_t ch=0, chn=0;
	while(ch<48)
	{
		LCDdefinechar((LcdCustomChar+ch),chn++);
		ch=ch+8;
	}
}

//toggle en
static void LCDtoggleEn()
{
	#if LCD_MIXED_PIN == 0
		LCD_PORT |= _BV(LCD_EN);//high
		_delay_us(LCD_EN_DELAY);
		LCD_PORT &= ~(_BV(LCD_EN));	//low
	#else
		LCD_EN_PORT |= _BV(LCD_EN_BIT);
		_delay_us(LCD_EN_DELAY);
		LCD_EN_PORT &= ~(_BV(LCD_EN_BIT));
	#endif
}

//check busy line
static void LCDwaitUntilNotBusy()
{
	#if (USE_BUSY_FLAG == 1)
		uint8_t bfst=255;
	
		#if LCD_MIXED_PIN == 0
			//make 4-7 as input
			LCD_DDR = 0x0f;
			LCD_PORT &= ~(_BV(LCD_RS) | _BV(LCD_EN));	//rs=en=0
			LCD_PORT |= _BV(LCD_RW) | 0xf0;	//rw=1, pullup on
			_delay_us(LCD_EN_DELAY);
		
			//check busy flag
			do
			{
				LCD_PORT |= _BV(LCD_EN);//high
				_delay_us(LCD_EN_DELAY);
				bfst = LCD_PIN;	//ambil bf dr nibble tggi
				LCD_PORT &= ~(_BV(LCD_EN));	//low
				_delay_us(LCD_EN_DELAY);
			
				LCD_PORT |= _BV(LCD_EN);//high
				_delay_us(LCD_EN_DELAY);
				LCD_PORT &= ~(_BV(LCD_EN));	//low
				_delay_us(LCD_EN_DELAY);
			} while ((bfst & 0x80) == 0x80);	//loop sampe tdk busy
		
			//restore as output
			LCD_PORT = 0;
			LCD_DDR = 0xff;
		#else
			//delay a bit
			_delay_ms(LCD_CMD_DELAY);
		
			//make D4-D7 as input
			LCD_D4_DDR &= ~(_BV(LCD_D4_BIT));
			LCD_D4_PORT |= _BV(LCD_D4_BIT);
			LCD_D5_DDR &= ~(_BV(LCD_D5_BIT));
			LCD_D5_PORT |= _BV(LCD_D5_BIT);
			LCD_D6_DDR &= ~(_BV(LCD_D6_BIT));
			LCD_D6_PORT |= _BV(LCD_D6_BIT);
			LCD_D7_DDR &= ~(_BV(LCD_D7_BIT));
			LCD_D7_PORT |= _BV(LCD_D7_BIT);
		
			//rs=en=0
			LCD_EN_PORT &= ~(_BV(LCD_EN_BIT));
			LCD_RS_PORT &= ~(_BV(LCD_RS_BIT));
		
			//rw=1
			LCD_RW_PORT |= _BV(LCD_RW_BIT);
		
			_delay_us(LCD_EN_DELAY);
		
			//check busy flag
			do
			{
				//LCD_EN = 1
				LCD_EN_PORT |= _BV(LCD_EN_BIT);
				_delay_us(LCD_EN_DELAY);
				//bfst = LCD_PIN;	//ambil bf dr nibble tggi
				bfst = LCD_D7_PIN & (1<<LCD_D7_PIN);
				//LCD_EN = 0
				LCD_EN_PORT &= ~(_BV(LCD_EN_BIT));
				_delay_us(LCD_EN_DELAY);
			
				//LCD_EN = 1
				LCD_EN_PORT |= _BV(LCD_EN_BIT);
				_delay_us(LCD_EN_DELAY);
				//LCD_EN = 0
				LCD_EN_PORT &= ~(_BV(LCD_EN_BIT));
				_delay_us(LCD_EN_DELAY);
			} //while ((bfst & 0x80) == 0x80);	//loop sampe tdk busy
			while(bfst == (1<<LCD_D7_PIN));
		
			//restore as output
			lcd_pin_mixed_setup();
		#endif	
	#else
		LCD_PORT &= ~(_BV(LCD_RW));	//make as output low state
		_delay_ms(LCD_CMD_DELAY);
	#endif
}

//send command to lcd
void LCDsendCommand(const uint8_t aCmd)
{
	#if LCD_MIXED_PIN == 0
		LCDwaitUntilNotBusy();
		LCD_PORT = (aCmd & 0xF0);	//send hi byte
		LCDtoggleEn();
		LCD_PORT = ((aCmd & 0x0F)<<4);	//send lo byte
		LCDtoggleEn();
		//_delay_us(LCD_DELAY_CMD);	//write delay
	#else
		LCDwaitUntilNotBusy();
		
		//send hi byte
		LCD_RS_PORT &= ~(_BV(LCD_RS_BIT));
		(aCmd & (1<<4)) ? (LCD_D4_PORT |= _BV(LCD_D4_BIT)):(LCD_D4_PORT &= ~(_BV(LCD_D4_BIT)));
		(aCmd & (1<<5)) ? (LCD_D5_PORT |= _BV(LCD_D5_BIT)):(LCD_D5_PORT &= ~(_BV(LCD_D5_BIT)));
		(aCmd & (1<<6)) ? (LCD_D6_PORT |= _BV(LCD_D6_BIT)):(LCD_D6_PORT &= ~(_BV(LCD_D6_BIT)));
		(aCmd & (1<<7)) ? (LCD_D7_PORT |= _BV(LCD_D7_BIT)):(LCD_D7_PORT &= ~(_BV(LCD_D7_BIT)));
		
		LCDtoggleEn();
		
		//send lo byte
		(aCmd & (1<<0)) ? (LCD_D4_PORT |= _BV(LCD_D4_BIT)):(LCD_D4_PORT &= ~(_BV(LCD_D4_BIT)));
		(aCmd & (1<<1)) ? (LCD_D5_PORT |= _BV(LCD_D5_BIT)):(LCD_D5_PORT &= ~(_BV(LCD_D5_BIT)));
		(aCmd & (1<<2)) ? (LCD_D6_PORT |= _BV(LCD_D6_BIT)):(LCD_D6_PORT &= ~(_BV(LCD_D6_BIT)));
		(aCmd & (1<<3)) ? (LCD_D7_PORT |= _BV(LCD_D7_BIT)):(LCD_D7_PORT &= ~(_BV(LCD_D7_BIT)));
		
		LCDtoggleEn();
	#endif	
}

void LCDsendChar(const uint8_t aData)
{
	#if LCD_MIXED_PIN == 0
		LCDwaitUntilNotBusy();
		LCD_PORT = (aData & 0xF0) | _BV(LCD_RS);	//send hi byte
		LCDtoggleEn();
		LCD_PORT = ((aData & 0x0F)<<4) | _BV(LCD_RS);	//send lo byte
		LCDtoggleEn();
		//_delay_us(LCD_DELAY_WRITE_DATA);	//write delay
	#else
		LCDwaitUntilNotBusy();
		//send hi byte
		LCD_RS_PORT |= _BV(LCD_RS_BIT);
		(aData & (1<<4)) ? (LCD_D4_PORT |= _BV(LCD_D4_BIT)):(LCD_D4_PORT &= ~(_BV(LCD_D4_BIT)));
		(aData & (1<<5)) ? (LCD_D5_PORT |= _BV(LCD_D5_BIT)):(LCD_D5_PORT &= ~(_BV(LCD_D5_BIT)));
		(aData & (1<<6)) ? (LCD_D6_PORT |= _BV(LCD_D6_BIT)):(LCD_D6_PORT &= ~(_BV(LCD_D6_BIT)));
		(aData & (1<<7)) ? (LCD_D7_PORT |= _BV(LCD_D7_BIT)):(LCD_D7_PORT &= ~(_BV(LCD_D7_BIT)));
		
		LCDtoggleEn();
		//send lo byte
		(aData & (1<<0)) ? (LCD_D4_PORT |= _BV(LCD_D4_BIT)):(LCD_D4_PORT &= ~(_BV(LCD_D4_BIT)));
		(aData & (1<<1)) ? (LCD_D5_PORT |= _BV(LCD_D5_BIT)):(LCD_D5_PORT &= ~(_BV(LCD_D5_BIT)));
		(aData & (1<<2)) ? (LCD_D6_PORT |= _BV(LCD_D6_BIT)):(LCD_D6_PORT &= ~(_BV(LCD_D6_BIT)));
		(aData & (1<<3)) ? (LCD_D7_PORT |= _BV(LCD_D7_BIT)):(LCD_D7_PORT &= ~(_BV(LCD_D7_BIT)));
		
		LCDtoggleEn();
	#endif
}

void LCDstring(uint8_t* aStr,const uint8_t Len)
{
	uint8_t i;
	for (i=0;i<Len;i++)
	{
		LCDsendChar(*aStr++);
	}
	
}

//Clears LCD
void LCDclr()
{
	LCDsendCommand(1<<LCD_CLR);
}

//LCD cursor home
void LCDhome()
{
	LCDsendCommand(1<<LCD_HOME);
}

//Cursor to X Y position
void LCDGotoXY(const uint8_t x, const uint8_t y)
{
	register uint8_t DDRAMAddr;
	// remap lines into proper order
	switch(y)
	{
		case 0: DDRAMAddr = LCD_LINE0_DDRAMADDR+x; break;
		case 1: DDRAMAddr = LCD_LINE1_DDRAMADDR+x; break;
		case 2: DDRAMAddr = LCD_LINE2_DDRAMADDR+x; break;
		case 3: DDRAMAddr = LCD_LINE3_DDRAMADDR+x; break;
		default: DDRAMAddr = LCD_LINE0_DDRAMADDR+x;
	}
	// set data address
	LCDsendCommand(_BV(LCD_DDRAM) | DDRAMAddr);
	
}

//defines char symbol in CGRAM
/*
const uint8_t backslash[] PROGMEM=
{
0b00000000,//back slash
0b00010000,
0b00001000,
0b00000100,
0b00000010,
0b00000001,
0b00000000,
0b00000000
};
LCDdefinechar(backslash,0);
*/
void LCDdefinechar(const uint8_t *pc,const uint8_t char_code){
	uint8_t a, pcc;
	uint16_t i;
	a=(char_code<<3)|0x40;
	for (i=0; i<8; i++){
		pcc=pgm_read_byte(&pc[i]);
		LCDsendCommand(a++);
		LCDsendChar(pcc);
	}
}

//Copies string from flash memory to LCD at x y position
//const uint8_t welcomeln1[] PROGMEM="AVR LCD DEMO\0";
//CopyStringtoLCD(welcomeln1, 3, 1);
void CopyStringtoLCD(const uint8_t *FlashLoc, const uint8_t x, const uint8_t y)
{
	uint8_t i;
	LCDGotoXY(x,y);
	for(i=0;(uint8_t)pgm_read_byte(&FlashLoc[i]);i++)
	{
		LCDsendChar((uint8_t)pgm_read_byte(&FlashLoc[i]));
	}
}

//Scrol n of characters Right
void LCDshiftLeft(const uint8_t n)
{
	uint8_t i;
	for (i=0;i<n;i++)
	{
		LCDsendCommand(0x1C);
	}
}

//Scrol n of characters Left
void LCDshiftRight(const uint8_t n)
{
	uint8_t i;
	for (i=0;i<n;i++)
	{
		LCDsendCommand(0x18);
	}
}

//displays LCD cursor
void LCDcursorOn()
{
	LCDsendCommand(0x0E);
}

//displays LCD blinking cursor
void LCDcursorOnBlink()
{
	LCDsendCommand(0x0F);
}

//turns OFF cursor
void LCDcursorOFF()
{
	LCDsendCommand(0x0C);
}

//blanks LCD
void LCDblank()
{
	LCDsendCommand(0x08);
}

//Shows LCD
void LCDvisible()
{
	LCDsendCommand(0x0C);
}

//Moves cursor by n poisitions left
void LCDcursorLeft(const uint8_t n)
{
	for (uint8_t i=0;i<n;i++)
	{
		LCDsendCommand(0x10);
	}
}

//Moves cursor by n poisitions left
void LCDcursorRight(const uint8_t n)
{
	for (uint8_t i=0;i<n;i++)
	{
		LCDsendCommand(0x14);
	}
}

//adapted fro mAVRLIB
void LCDprogressBar(const uint8_t x, const uint8_t y, const uint8_t reversed, const uint8_t progress, const uint8_t maxprogress, const uint8_t length)
{
	uint8_t i, j;
	uint16_t pixelprogress;
	uint8_t c;
	
	LCDGotoXY(x,y);

	// draw a progress bar displaying (progress / maxprogress)
	// starting from the current cursor position
	// with a total length of "length" characters
	// ***note, LCD chars 0-5 must be programmed as the bar characters
	// char 0 = empty ... char 5 = full

	// total pixel length of bargraph equals length*PROGRESSPIXELS_PER_CHAR;
	// pixel length of bar itself is
	pixelprogress = ((progress*(length*PROGRESSPIXELS_PER_CHAR))/maxprogress);
	
	// print exactly "length" characters
	for(i=0; i<length; i++)
	{
		// reverse or not
		if (reversed)
		{
			j = length - 1 - i;
		}
		else
		{
			j = i;
		}
		
		// check if this is a full block, or partial or empty
		// (u16) cast is needed to avoid sign comparison warning
		if( ((j*(uint16_t)PROGRESSPIXELS_PER_CHAR)+5) > pixelprogress )
		{
			// this is a partial or empty block
			if( ((j*(uint16_t)PROGRESSPIXELS_PER_CHAR)) > pixelprogress )
			{
				// this is an empty block
				// use space character?
				c = 0;
			}
			else
			{
				// this is a partial block
				c = pixelprogress % PROGRESSPIXELS_PER_CHAR;
			}
		}
		else
		{
			// this is a full block
			c = 5;
		}
		
		// write character to display
		LCDsendChar(c);
	}

}

#if LCD_USE_FILESTREAM == 1
//send lcd data from stream version
static int LCDsendCharStream(char ch, FILE *stream)
{
	LCDsendChar((uint8_t) ch);
	return 0;
}

//printf for the lcd
void LCDprintf(const uint8_t use_flash, const uint8_t xpos, const uint8_t ypos, const char *fmt, ...)
{
	va_list arglist;
	
	LCDGotoXY(xpos,ypos);
	
	va_start(arglist,fmt);
	if (use_flash)
	{
		vfprintf_P(&LCDInputOutputStream,fmt,arglist);
	} 
	else
	{
		vfprintf(&LCDInputOutputStream,fmt,arglist);
	}
	
	va_end(arglist);
}
#endif