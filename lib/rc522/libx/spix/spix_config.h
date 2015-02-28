/*
SPI MASTER AVR CONFIG
*/
#ifndef SPIX_CONFIG_H
#define SPIX_CONFIG_H

// header file
#include <io.h>

/*
 * Set to 1, spi api will work in master mode
 * else in slave mode
 */
#define SPI_CONFIG_AS_MASTER 	1


/*
 * Config SPI pin diagram
 */
#define SPI_DDR		DDRB
#define SPI_PORT	PORTB
#define SPI_PIN		PINB
#define SPI_SS		PORTB4
#define SPI_MOSI	PORTB5
#define SPI_MISO	PORTB6
#define SPI_SCK		PORTB7

#endif
