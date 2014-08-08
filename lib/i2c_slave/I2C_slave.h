#ifndef I2C_SLAVE_H
#define I2C_SLAVE_H

//buffer number in byte-1
#define I2C_BUFF_NUM	8

//global variable
volatile uint8_t buffer_address;
volatile uint8_t txbuffer[I2C_BUFF_NUM];
volatile uint8_t rxbuffer[I2C_BUFF_NUM];

//proto function
void I2C_init(uint8_t address);
void I2C_stop(void);
ISR(TWI_vect);

#endif // I2C_SLAVE_H
