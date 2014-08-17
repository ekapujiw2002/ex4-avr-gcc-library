/*
* lcd_lib.h
*
* Created: 9/5/2012 10:45:43 AM
*  Author: EX4
*/

/**
*  @defgroup ex4_lcd LCD Character
*  @code #include "lcd_lib.h" @endcode
*
*  @brief	LCD character library for avr with gcc. Support printf function and mixed mode pin.
*
*  @note	-
*  @author	EX4 ekapujiw2002@gmail.com  http://ex4-tech.id.or.id
*/
/**@{*/

#ifndef LCD_LIB_H_
#define LCD_LIB_H_

//used lib
#include <inttypes.h>
#include <util/delay.h>
#include <avr/pgmspace.h>

//c++ wrapper
#ifdef __cplusplus
	extern "C" {
#endif

/**
* Use file stream or not (printf functionality)
*/
#define LCD_USE_FILESTREAM	1

#if LCD_USE_FILESTREAM == 1
#include <stdio.h>
#include <stdarg.h>
#endif

//delay const
/**
* LCD delay for enable signal in microsecond
*/
#define LCD_EN_DELAY		1

/**
* LCD delay for command in millisecond. ADJUST WITH YOUR OWN LCD!!!
*/
#define LCD_CMD_DELAY		2

/**
* Use SIPO 74HC595 ic or not. If it is on then all the other pin arrangement will be ignored. \n
* You need to use 74HC595 chip with the LCD pin connected as below configuration.
*/
#define LCD_USE_SIPO_74HC595	1

#if LCD_USE_SIPO_74HC595 == 1

/**
* using sipo
*/
/**
* SIPO 74HC595 pin connection
*/
#define HC595_PORT   	PORTB
#define HC595_DDR    	DDRB
#define HC595_DS_POS 	PB0      //Data pin (DS) pin location
#define HC595_SH_CP_POS PB1      //Shift Clock (SH_CP) pin location
#define HC595_ST_CP_POS PB2      //Store Clock (ST_CP) pin location

/**
* LCD pin arrangement. RW pin is tied to GND. Arrangement pin is free i.e. you can mix it
*/
#define LCD_SIPO_RS	0
#define LCD_SIPO_EN	1
#define LCD_SIPO_D4	2
#define LCD_SIPO_D5	3
#define LCD_SIPO_D6	4
#define LCD_SIPO_D7	5

/**
* sipo constant define
*/
#define SIPO_LATCH_ON	1

/**
* Low level macros to change data (DS)lines
*/
#define HC595DataHigh() (HC595_PORT|=_BV(HC595_DS_POS))
#define HC595DataLow() (HC595_PORT&=~_BV(HC595_DS_POS))

#else

/**
* not using sipo
*/
/**
* Use mixed pin for lcd (1 = yes, 0 = no)
*/
#define LCD_MIXED_PIN	0

/**
* Use pin LCD R/W or not. If not using busy flag then tied RW pin to GND
*/
#define USE_BUSY_FLAG	1

/**
* Lcd port and pin configuration in mixed or aligned pin
*/
#if LCD_MIXED_PIN == 0
/**
* Aligned mode \n
* In aligned mode bit 4-7 of the port is used for bit 4-7 of lcd data port
*/
/**
* Port name for LCD
*/
#define LCD_PORT	PORTB
/**
* DDR name for the LCD
*/
#define LCD_DDR		DDRB
/**
* PIN name for LCD
*/
#define LCD_PIN		PINB
/**
* Pin number for LCD RS
*/
#define LCD_RS		0
/**
* Pin number for LCD RW
*/
#define LCD_RW		1
/**
* Pin number for LCD EN
*/
#define LCD_EN		2
#else

/**
* Mixed mode
*/
#define LCD_RS_PORT	PORTB
#define LCD_RS_DDR	DDRB
#define LCD_RS_BIT	PB0
#if (USE_BUSY_FLAG == 1)
#define LCD_RW_PORT	PORTB
#define LCD_RW_DDR	DDRB
#define LCD_RW_BIT	PB1
#endif
#define LCD_EN_PORT	PORTB
#define LCD_EN_DDR	DDRB
#define LCD_EN_BIT	PB2

/**
* Extended port lcd data
*/
#define LCD_D4_PORT	PORTB
#define LCD_D4_DDR	DDRB
#define LCD_D4_BIT	PB4
#define LCD_D5_PORT	PORTB
#define LCD_D5_DDR	DDRB
#define LCD_D5_BIT	PB5
#define LCD_D6_PORT	PORTB
#define LCD_D6_DDR	DDRB
#define LCD_D6_BIT	PB6
#define LCD_D7_PORT	PORTB
#define LCD_D7_DDR	DDRB
#define LCD_D7_PIN	PINB
#define LCD_D7_BIT	PB7
#endif
#endif

/**
* Use data from ram
*/
#define LCD_USE_RAM		0

/**
* Use data from flash memory
*/
#define LCD_USE_FLASH	1

/**
* Progressbar direction from left to right
*/
#define LCD_PROGRESSBAR_FORWARD		0

/**
* Progressbar direction from right to left
*/
#define LCD_PROGRESSBAR_BACKWARD	1

//lcd command list
/**
* Clear LCD display
*/
#define LCD_CLR             0	//DB0: clear display

/**
* Set cursor to home position
*/
#define LCD_HOME            1	//DB1: return to home position

/**
* Set entry mode
*/
#define LCD_ENTRY_MODE      2	//DB2: set entry mode

/**
* Auto increment LCD cursor
*/
#define LCD_ENTRY_INC       1	//DB1: increment

/**
* Shift LCD cursor
*/
#define LCD_ENTRY_SHIFT     0	//DB2: shift

/**
* Cursor LCD control
*/
#define LCD_ON_CTRL         3	//DB3: turn lcd/cursor on

/**
* Display on
*/
#define LCD_ON_DISPLAY      2	//DB2: turn display on

/**
* Cursor LCD on
*/
#define LCD_ON_CURSOR       1	//DB1: turn cursor on

/**
* Blinking cursor LCD
*/
#define LCD_ON_BLINK        0	//DB0: blinking cursor

/**
* Move LCD cursor
*/
#define LCD_MOVE            4	//DB4: move cursor/display

/**
* Move display
*/
#define LCD_MOVE_DISP       3	//DB3: move display (0-> move cursor)

/**
* Move to the right
*/
#define LCD_MOVE_RIGHT      2	//DB2: move right (0-> left)

/**
* LCD function set
*/
#define LCD_FUNCTION        5	//DB5: function set

/**
* 8 bit interface bit definition
*/
#define LCD_FUNCTION_8BIT   4	//DB4: set 8BIT mode (0->4BIT mode)
#define LCD_FUNCTION_2LINES 3	//DB3: two lines (0->one line)
#define LCD_FUNCTION_10DOTS 2	//DB2: 5x10 font (0->5x7 font)
#define LCD_CGRAM           6	//DB6: set CG RAM address
#define LCD_DDRAM           7	//DB7: set DD RAM address
// reading:
#define LCD_BUSY            7	//DB7: LCD is busy

/**
* LCD screen size row and column, support for lcd with single ENABLE LINE (40x2 max)
*/
//#define LCD_LINES			2	//visible lines
//#define LCD_LINE_LENGTH		16	//line length (in characters)

// cursor position to DDRAM mapping
/**
* LCD memory position for many lines
*/
#define LCD_LINE0_DDRAMADDR		0x00
#define LCD_LINE1_DDRAMADDR		0x40
#define LCD_LINE2_DDRAMADDR		0x14
#define LCD_LINE3_DDRAMADDR		0x54

// progress bar defines
#define PROGRESSPIXELS_PER_CHAR	6

/**
* Initialize LCD pin setting and data
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDinit();

/**
* Go to a lcd position cursor
* @author	EX4
* @version	1.0
* @param	x	LCD row from 0
* @param	y	LCD column from 0
* @return	-
*/
void LCDGotoXY(const uint8_t x, const uint8_t y);

/**
* Send command to lcd
* @author	EX4
* @version	1.0
* @param	aCmd	Command to be sent to LCD controller
* @return	-
*/
void LCDsendCommand(const uint8_t aCmd);

/**
* Send char to lcd
* @author	EX4
* @version	1.0
* @param	aData	Char to be sent
* @return	-
*/
void LCDsendChar(const uint8_t aData);

/**
* Send string from RAM. Just use LCDprintf function
* @author	EX4
* @version	1.0
* @param	aStr	String to be sent
* @param	Len		String length
* @return	-
*/
void LCDstring(uint8_t* aStr,const uint8_t Len);

/**
* Clear screen
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDclr();

/**
* Back to home cursor
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDhome();

/**
* Copy pgm string to lcd
* @author	EX4
* @version	1.0
* @param	*FlashLoc	Flash string
* @param	x			Row position
* @param	y			Column position
* @return	-
*/
void CopyStringtoLCD(const uint8_t *FlashLoc, const uint8_t x, const uint8_t y);//copies flash string to LCD at x,y

/**
* Define custom char
* @author	EX4
* @version	1.0
* @param	*pc	Flash memori for the custo char data
* @param	char_code	Character code to be used(0-7)
* @return
*/
void LCDdefinechar(const uint8_t *pc,uint8_t char_code);//write char to LCD CGRAM

/**
* Define progress bar char as char0-5
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDDefineProgressBarChar();

/**
* Shift display right
* @author	EX4
* @version	1.0
* @param	n	Shift values
* @return	-
*/
void LCDshiftRight(const uint8_t n);	//shift by n characters Right

/**
* Shift display left
* @author	EX4
* @version	1.0
* @param	n	Shift values
* @return	-
*/
void LCDshiftLeft(const uint8_t n);	//shift by n characters Left

/**
* Cursor on
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDcursorOn();		//Underline cursor ON

/**
* Cursor on and blinking
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDcursorOnBlink();	//Underline blinking cursor ON

/**
* Cursor off
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDcursorOFF();		//Cursor OFF

/**
* LCD blank
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDblank();			//LCD blank but not cleared

/**
* Make LCD visible
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
void LCDvisible();			//LCD visible

/**
* Cursor to the left
* @author	EX4
* @version	1.0
* @param	n	Shift values
* @return	-
*/
void LCDcursorLeft(const uint8_t n);	//Shift cursor left by n

/**
* Cursor to the right
* @author	EX4
* @version	1.0
* @param	n	Shift values
* @return	-
*/
void LCDcursorRight(const uint8_t n);	//shif cursor right by n

/**
* Displays a horizontal progress bar at the current cursor location. adapted from AVRLIB - displays progress only for 8 bit variables
* @author	EX4
* @version	1.0
* @param	x	Row position
* @param	y	Column position
* @param	progress	Value the bargraph should indicate
* @param	maxprogress	Value at the end of the bargraph
* @param	length	Number of LCD characters that the bargraph should cover
* @return	-
*/
void LCDprogressBar(const uint8_t x, const uint8_t y, const uint8_t reversed, const uint8_t progress, const uint8_t maxprogress, const uint8_t length);

/**
* Print to lcd using printf
* @author	EX4
* @version	1.0
* @param	use_flash	Format from RAM or FLASH
* @param	xpos	Row position
* @param	ypos	Column position
* @param	*fmt	Format of data
* @param	...	Argument list
* @return	-
*/
#if LCD_USE_FILESTREAM == 1
void LCDprintf(const uint8_t use_flash, const uint8_t xpos, const uint8_t ypos, const char *fmt, ...);
#endif

/**
* Structure for lcd object
* @author	EX4
* @version	1.0
* @param	-
* @return	-
*/
struct lcd_struct
{
	void (*initialize)();
	void (*home)();
	void (*position)(const uint8_t x, const uint8_t y);
	void (*command)(const uint8_t aCmd);
	void (*clear)();
	void (*text)(uint8_t* aStr,uint8_t Len);
	void (*flash_text)(const uint8_t *FlashLoc, const uint8_t x, const uint8_t y);
	void (*custom_char)(const uint8_t *pc,const uint8_t char_code);
	void (*init_progressbar)();
	void (*shift_right)(const uint8_t n);
	void (*shift_left)(const uint8_t n);
	#if LCD_USE_FILESTREAM == 1
	void (*printf)(const uint8_t use_flash, const uint8_t xpos, const uint8_t ypos, const char *fmt, ...);
	#endif
	void (*cursor_on)();
	void (*cursor_on_blink)();
	void (*cursor_off)();
	void (*blank)();
	void (*visible)();
	void (*cursor_left)(const uint8_t n);
	void (*cursor_right)(const uint8_t n);
	void (*progress_bar)(const uint8_t x, const uint8_t y, const uint8_t reversed, const uint8_t progress, const uint8_t maxprogress, const uint8_t length);
}
//default value
static const lcd_struct_default = {
	LCDinit,
	LCDhome,
	LCDGotoXY,
	LCDsendCommand,
	LCDclr,
	LCDstring,
	CopyStringtoLCD,
	LCDdefinechar,
	LCDDefineProgressBarChar,
	LCDshiftRight,
	LCDshiftLeft,
	#if LCD_USE_FILESTREAM == 1
	LCDprintf,
	#endif
	LCDcursorOn,
	LCDcursorOnBlink,
	LCDcursorOFF,
	LCDblank,
	LCDvisible,
	LCDcursorLeft,
	LCDcursorRight,
	LCDprogressBar
};

/**
* @brief	LCD structure data type definition
*/
typedef struct lcd_struct lcd_t;

//c++ wrapper
#ifdef __cplusplus
}
#endif

#endif /* LCD_LIB_H_ */
/**@}*/
