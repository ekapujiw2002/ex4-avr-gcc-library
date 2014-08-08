/*
* i2c_gps.c
*
* Created: 3/4/2014 3:21:16 PM
*  Author: EX4
*/

#include "i2c_gps.h"

/*
* i2c write
*/
void i2c_gps_writemem(uint8_t reg, uint8_t value) {
	i2c_start_wait(I2C_GPS_ADDRESS | I2C_WRITE);
	i2c_write(reg);
	i2c_write(value);
	i2c_stop();
}

/*
* i2c read
*/
void i2c_gps_readmem(uint8_t reg, uint8_t buff[], uint8_t bytes) {
	uint8_t i =0;
	i2c_start_wait(I2C_GPS_ADDRESS | I2C_WRITE);
	i2c_write(reg);
	i2c_rep_start(I2C_GPS_ADDRESS | I2C_READ);
	for(i=0; i<bytes; i++) {
		if(i==bytes-1)
		buff[i] = i2c_readNak();
		else
		buff[i] = i2c_readAck();
	}
	i2c_stop();
}

/*
read gps status
*/
uint8_t i2c_gps_read_status()
{
	uint8_t aval;
	i2c_gps_readmem(I2C_GPS_STATUS_00,&aval,1);
	return aval;
}

/*
read lat lon
*/
void i2c_gps_read_lat_lon(int32_t *latx, int32_t *lonx)
{
	uint8_t buff[8];
	
	i2c_gps_readmem(I2C_GPS_LOCATION,buff,8);
	
	//convert ke long, big endian data
	memcpy(latx, &buff[0], 4);
	memcpy(lonx, &buff[4], 4);
}

/*
* read i2c gps ground 2d speed(m/s), altitude(m)
* */
void i2c_gps_read_speed_altitude(uint16_t *speed, uint16_t *altitude)
{
	uint8_t buff[4];
	
	i2c_gps_readmem(I2C_GPS_GROUND_SPEED,buff,4);
	
	//convert ke unsigned short, big endian data
	memcpy(speed, &buff[0], 2);
	memcpy(altitude, &buff[2], 2);
}

/*
* read i2c gps time in msec
* */
void i2c_gps_read_time(uint32_t *gps_time)
{
	uint8_t buff[4];
	
	i2c_gps_readmem(I2C_GPS_TIME,buff,4);
	
	//convert ke unsigned long, big endian data
	memcpy(gps_time, &buff[0], 4);
}
