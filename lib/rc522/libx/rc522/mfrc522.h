/*
 * mfrc522.h
 * 
 * Copyright 2013 Shimon <shimon@monistit.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
#ifndef MFRC522_H
#define MFRC522_H

#include <stdint.h>
#include <mfrc522_cmd.h>
#include <mfrc522_reg.h>

#define CARD_FOUND		1
#define CARD_NOT_FOUND	2
#define ERROR			3

#define MAX_LEN			16

//Card types
#define Mifare_UltraLight 	0x4400
#define Mifare_One_S50		0x0400
#define Mifare_One_S70		0x0200
#define Mifare_Pro_X		0x0800
#define Mifare_DESFire		0x4403

// Mifare_One card command word
#define PICC_REQIDL          0x26               // find the antenna area does not enter hibernation
#define PICC_REQALL          0x52               // find all the cards antenna area
#define PICC_ANTICOLL        0x93               // anti-collision
#define PICC_SElECTTAG       0x93               // election card
#define PICC_AUTHENT1A       0x60               // authentication key A
#define PICC_AUTHENT1B       0x61               // authentication key B
#define PICC_READ            0x30               // Read Block
#define PICC_WRITE           0xA0               // write block
#define PICC_DECREMENT       0xC0               // debit
#define PICC_INCREMENT       0xC1               // recharge
#define PICC_RESTORE         0xC2               // transfer block data to the buffer
#define PICC_TRANSFER        0xB0               // save the data in the buffer
#define PICC_HALT            0x50               // Sleep

//MF522 command word
#define PCD_IDLE              0x00               //NO action; cancel the current command
#define PCD_AUTHENT           0x0E               // authentication key
#define PCD_RECEIVE           0x08               // receive data
#define PCD_TRANSMIT          0x04               // Transmit Data
#define PCD_TRANSCEIVE        0x0C               // Send and receive data
#define PCD_RESETPHASE        0x0F               // Reset
#define PCD_CALCCRC           0x03               // CRC calculation

//key default A and B
extern uint8_t keyA_default[6];
extern uint8_t keyB_default[6];

//proto function
void mfrc522_init();
void mfrc522_reset();
void mfrc522_write(uint8_t reg, uint8_t data);
uint8_t mfrc522_read(uint8_t reg);
uint8_t	mfrc522_request(uint8_t req_mode, uint8_t * tag_type);
uint8_t mfrc522_to_card(uint8_t cmd, uint8_t *send_data, uint8_t send_data_len, uint8_t *back_data, uint32_t *back_data_len);
uint8_t mfrc522_get_card_serial(uint8_t * serial_out);
void mfrc522_setBitMask(uint8_t reg, uint8_t mask);
void mfrc522_clearBitMask(uint8_t reg, uint8_t mask);
void mfrc522_calculateCRC(uint8_t *pIndata, uint8_t len, uint8_t *pOutData);
uint8_t mfrc522_halt();
uint8_t mfrc522_get_version();
uint8_t mfrc522_is_card(uint16_t *card_type);
uint8_t mfrc522_auth(uint8_t authMode, uint8_t BlockAddr, uint8_t *Sectorkey, uint8_t *serNum);
uint8_t mfrc522_write_block(uint8_t blockAddr, uint8_t *writeData);
uint8_t mfrc522_read_block(uint8_t blockAddr, uint8_t *recvData);
uint8_t mfrc522_select_tag(uint8_t *serNum);

#endif
