/*
 * bit_util.h
 *
 * Created: 7/5/2014 5:29:17 AM
 *  Author: EX4
 * Description :
 * Some macros to ease the work with bit and port or variables
 *
 * Reference :
 * http://www.avrfreaks.net
 */ 

/*
Example :
To set a bit 5 on DDRA		: bit_set(DDRA, BIT(5));
To set bit 0,3,6 on DDRA	: bit_set(DDRA, BIT(6) | BIT(3) | BIT(0));
To clear bit 5 on DDRA		: bit_clear(DDRA, BIT(5));
To clear bit 0,3,6 on DDRA	: bit_clear(DDRA, BIT(6) | BIT(3) | BIT(0));
To read bit 3 on PINA		:
	if(bit_get(PINA, BIT(3)))
	{
		..........
	}
To set bit 4 on PORTA based on bit 2 on PINA :
	bit_write(bit_get(PINA, BIT(2)), PORTA, BIT(4));		
To toggle bit 2 on PORTA	: bit_toggle(PORTA, BIT(2));	
*/

/**
*  @defgroup ex4_bit_util Bit Utility
*  @code #include "bit_util.h" @endcode
*
*  @brief	Macros for easy bit manipulation on AVR.
*
*  @note	Based on http://www.avrfreaks.net
*  @author	EX4 ekapujiw2002@gmail.com  http://ex4-tech.id.or.id
*/
/**@{*/
	
#ifndef BIT_UTIL_H_
#define BIT_UTIL_H_

/**
* Set bit at position x
* @author		EX4
* @version		1.0
* @param		x		bit number(0-7)
* @return		uint8_t	value from 0-255
*/
#define BIT(x)				(0x01 << (x))

/**
* Define 32 bit value with position bit x
* @author		EX4
* @version		1.0
* @param		x			bit number(0-31)
* @return		uint32_t	unsigned long return
*/
#define LONGBIT(x)			((uint32_t) 0x00000001 << (x))

/**
* Get value for a value of p at bit number m. Example :
* To read bit 3 on PINA
* @code
* if(bit_get(PINA, BIT(3)))
* {
*	..........
* }
* @endcode
* @author	EX4
* @version	1.0
* @param	p	Pin,port, or value
* @param	m	Bit number
* @return	uint8_t	bit value of m(0/1)
*/
#define bit_get(p,m)		((p) & (m))

/**
* Set value for a value of p at bit number m. Example :
* To set bit 3 on PINA
* @code
* bit_set(PINA, BIT(3));
* @endcode
* @author	EX4
* @version	1.0
* @param	p	Pin,port, or value
* @param	m	Bit number
* @return	-
*/
#define bit_set(p,m)		((p) |= (m))

/**
* Clear value for a value of p at bit number m. Example :
* To clear bit 3 on PINA
* @code
* bit_clear(PINA, BIT(3));
* @endcode
* @author	EX4
* @version	1.0
* @param	p	Pin,port, or value
* @param	m	Bit number
* @return	-
*/
#define bit_clear(p,m)		((p) &= ~(m))

/**
* Toggle value for a value of p at bit number m. Example :
* To toggle bit 3 on PINA
* @code
* bit_toggle(PINA, BIT(3));
* @endcode
* @author	EX4
* @version	1.0
* @param	p	Pin,port, or value
* @param	m	Bit number
* @return	-
*/
#define bit_toggle(p,m)		((p) ^= (m))

/**
* Set value for a value of p at bit number m based on value of c. Example :
* To set bit 4 on PORTA based on bit 2 on PINA :
* @code
* bit_write(bit_get(PINA, BIT(2)), PORTA, BIT(4));
* @endcode
* @author	EX4
* @version	1.0
* @param	c	Bit based value
* @param	p	Pin,port, or value
* @param	m	Bit number
* @return	-
*/
#define bit_write(c,p,m)	(c ? bit_set(p,m) : bit_clear(p,m))

#endif /* BIT_UTIL_H_ */
/**@}*/