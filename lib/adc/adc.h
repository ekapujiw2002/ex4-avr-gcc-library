/*
 * adc.h
 *
 * Created: 6/21/2012 10:22:44 AM
 *  Author: EX4
 */ 
/**
*  @defgroup ex4_adc ADC
*  @code #include "adc.h" @endcode
*
*  @brief	ADC AVR internal library.
*
*  @note	-
*  @author	EX4 ekapujiw2002@gmail.com  http://ex4-tech.id.or.id
*/
/**@{*/

#ifndef ADC_H_
#define ADC_H_

/**
* AVR library
*/
#include <avr/io.h>

//define
/**
* ADC reference external voltage
*/
#define ADC_VREF_AREF	0

/**
* ADC reference same as VCC
*/
#define ADC_VREF_AVCC	1

/**
* ADC reference using internal reference 
*/
#define ADC_VREF_INTERNAL	3

/**
* ADC output at 8 bit resolution
*/
#define ADC_DATA_8BIT	1

/**
* ADC output at 10 bit resolution
*/
#define ADC_DATA_10BIT	0

/**
* ADC channel 0
*/
#define ADC_CH0	0

/**
* ADC channel 1
*/
#define ADC_CH1	1

/**
* ADC channel 2
*/
#define ADC_CH2	2

/**
* ADC channel 3
*/
#define ADC_CH3	3

/**
* ADC channel 4
*/
#define ADC_CH4	4

/**
* ADC channel 5
*/
#define ADC_CH5	5

/**
* ADC channel 6
*/
#define ADC_CH6	6

/**
* ADC channel 7
*/
#define ADC_CH7	7

/**
* ADC clock prescaler 1
*/
#define ADC_PSC2	1

/**
* ADC clock prescaler 4
*/
#define ADC_PSC4	(ADC_PSC2+1)

/**
* ADC clock prescaler 8
*/
#define ADC_PSC8	(ADC_PSC2+2)

/**
* ADC clock prescaler 16
*/
#define ADC_PSC16	(ADC_PSC2+3)

/**
* ADC clock prescaler 32
*/
#define ADC_PSC32	(ADC_PSC2+4)

/**
* ADC clock prescaler 64
*/
#define ADC_PSC64	(ADC_PSC2+5)

/**
* ADC clock prescaler 128
*/
#define ADC_PSC128	(ADC_PSC2+6)

/**
* Init ADC with selected voltage reference, data bit, and clock prescaler
* @author	EX4
* @version	1.0
* @param	Vref	ADC voltage reference
* @param	DataBit	ADC bit resolution
* @param	Psc		ADC clock prescaler
* @return	-
*/
void ADC_Init(const uint8_t Vref, const uint8_t DataBit, const uint8_t Psc);

/**
* Get ADC data from channel 0-7
* @author	EX4
* @version	1.0
* @param	aChannel	ADC channel 0-7
* @return	ADC data value
*/
uint16_t ADC_ReadData(const uint8_t aChannel);

/**
* ADC structure data
* @author	EX4
* @version	1.0
* @param	*init	Initialize adc setting @see ADC_Init
* @param	*read	Read adc data from a channel @see ADC_ReadData
* @return	-
*/
typedef struct adc_struct
{
	void (*init)(const uint8_t Vref, const uint8_t DataBit, const uint8_t Psc);
	uint16_t (*read)(const uint8_t aChannel);
} adc_t; 

/**
* Set a default value to be used. Make sure it is \bstatic and \bconstant
*/
static const adc_t adc_struct_default = {ADC_Init, ADC_ReadData};

#endif /* ADC_H_ */
/**@}*/