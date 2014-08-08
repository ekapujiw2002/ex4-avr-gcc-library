/*
* adc.c
*
* Created: 6/21/2012 10:22:53 AM
*  Author: EX4
*/

//lib
#include "adc.h"

//proto for static func void

//void and func
static void ADC_SetVref(const uint8_t aVrefMode);
static void ADC_SetDataBit(const uint8_t aDataBit);
static void ADC_SetChannel(const uint8_t aChannel);
static void ADC_ONOFF(const uint8_t isON);
static void ADC_SetPrescalar(const uint8_t Psc);
static void ADC_StartSingleConversion();
static void ADC_WaitConversionComplete();
static void ADC_ClearFlagComplete();

/*
set vref
*/
static void ADC_SetVref(const uint8_t aVrefMode)
{
	ADMUX =(ADMUX & ~(_BV(REFS1) | _BV(REFS0))) | (aVrefMode<<REFS0);
}

static void ADC_SetDataBit(const uint8_t aDataBit)
{
	ADMUX = (ADMUX & ~(_BV(ADLAR))) | (aDataBit<<ADLAR);
}

static void ADC_SetChannel(const uint8_t aChannel)
{
	ADMUX = (ADMUX & 0b11100000) | aChannel;
}

static void ADC_ONOFF(const uint8_t isON)
{
	ADCSRA = (ADCSRA & ~(_BV(ADEN))) | (isON<<ADEN);
}

static void ADC_SetPrescalar(const uint8_t Psc)
{
	ADCSRA =(ADCSRA & 0b11111000) | Psc;
}

static void ADC_StartSingleConversion()
{
	ADCSRA =(ADCSRA & ~(_BV(ADSC))) | _BV(ADSC);
}

static void ADC_WaitConversionComplete()
{
	loop_until_bit_is_set(ADCSRA,ADIF);
}

static void ADC_ClearFlagComplete()
{
	ADCSRA |= _BV(ADIF);
}

void ADC_Init(const uint8_t Vref, const uint8_t DataBit, const uint8_t Psc)
{
	ADC_SetVref(Vref);
	ADC_SetChannel(ADC_CH0);
	ADC_SetDataBit(DataBit);
	ADC_SetPrescalar(Psc);
	ADC_StartSingleConversion();
	ADC_ONOFF(1);
}

uint16_t ADC_ReadData(const uint8_t aChannel)
{
	ADC_SetChannel(aChannel);
	ADC_StartSingleConversion();
	ADC_WaitConversionComplete();
	ADC_ClearFlagComplete();
	
	if (bit_is_set(ADMUX,ADLAR))	//8bit
	{
		return ADCH;
	}
	else
	{
		return ADC;
	}
}