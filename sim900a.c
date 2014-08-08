/*
* sim900a.c
*
* Created: 7/22/2014 10:32:33 AM
*  Author: EX4
*/

//lib
#include <stddef.h>
#include <string.h>
#include <stdlib.h>	//for calloc, atoi

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#include "lib/uart.h"
#include "lib/lcd_lib.h"

#define USART_BAUD_RATE	38400
#define CR_CHAR			'\r'

#define RESPON_OK		"OK"
#define RESPON_ERROR	"ERROR"

#define CMD_AT	"AT\r"

#define HTTP_GET	0
#define HTTP_POST	1

//read all rx buffer
//reset buffer
void uart_flush_buffer()
{
	while (uart_getc() != UART_NO_DATA)
	;
}

//send cmd to serial and wait respon
uint8_t sim900_send_cmd_wait_reply(const uint8_t send_from_progmem, const uint8_t *aCmd, const uint8_t
*aResponExit, const uint32_t aTimeoutMax, const uint8_t aLenOut, uint8_t
*aResponOut)
{
	#define MAX_BUFFER_TMP	64

	uint8_t id_data, /*aDataBuffer[MAX_BUFFER_TMP],*/ respons = 0;
	uint32_t uart_tout_cnt = 0;
	uint16_t uart_data;
	
	uint8_t *aDataBuffer = (uint8_t*) calloc(MAX_BUFFER_TMP,sizeof(uint8_t));
	
	//buffer created???
	if (aDataBuffer == NULL)
	{
		return 0;
	}

	//reset to all 0
	memset(aDataBuffer, '\0', MAX_BUFFER_TMP);

	//read left buffer data
	if (aCmd != NULL)
	{
		uart_flush_buffer();
	}

	//send command
	if (aCmd != NULL)
	{
		if (send_from_progmem)
		{
			uart_puts_p((const char*)aCmd);
		} 
		else
		{
			uart_puts((const char*)aCmd);
		}
	}

	//wait for reply
	id_data = 0;
	uart_tout_cnt = 0;
	while ((id_data < (MAX_BUFFER_TMP - 1)) && (uart_tout_cnt <= aTimeoutMax))
	{
		//get uart data or timeout
		uart_tout_cnt = 0;
		while (((uart_data = uart_getc()) == UART_NO_DATA) && (uart_tout_cnt <
		aTimeoutMax))
		//wait data arrive or tout
		{
			uart_tout_cnt++;
			_delay_us(1);
		}

		//check for timeout
		if (uart_tout_cnt >= aTimeoutMax)
		{
			respons = 0;
			break;
		}
		else
		{
			aDataBuffer[id_data] = uart_data;
			id_data++;

			// check if the desired answer  is in the response of the module
			if (aResponExit != NULL)
			{
				if (strstr((const char*)aDataBuffer, (const char*)aResponExit) != NULL)
				{
					respons = 1;
					break;
				}
			}

			//check error also
			if (strstr((const char*)aDataBuffer, (const char*)RESPON_ERROR) != NULL)
			{
				respons = 0;
				break;
			}
		}
	}

	//copy it to the out
	if ((aLenOut != 0) && (aResponOut != NULL) && (aLenOut > id_data) && (respons)
	)
	{
		memcpy(aResponOut, aDataBuffer, id_data *sizeof(uint8_t));
	}
	
	//free the buffer
	free(aDataBuffer);

	//return it
	return respons;
}

//cek network status
uint8_t sim900_is_network_registered()
{
	return (sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT+CREG?\r"), (const
	uint8_t*)"+CREG: 0,1", 5000000, 0, NULL) || sim900_send_cmd_wait_reply(1,
	(const uint8_t*)PSTR("AT+CREG?\r"), (const uint8_t*)"+CREG: 0,5", 5000000, 0,
	NULL));
}

//setup sim900
uint8_t sim900_setup(const uint8_t isWaitingDevice)
{
	uint8_t respons = 0;

	//wait modem wake up
	if (isWaitingDevice)
	{
		while (!(respons = sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT\r"),
		(const uint8_t*)RESPON_OK, 500000, 0, NULL)))
		;
	}
	else
	{
		respons = sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT\r"), (const
		uint8_t*)RESPON_OK, 500000, 0, NULL);
	}

	//modem is up?
	if (respons)
	{
		//no cmd echo
		if ((respons = sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("ATE0\r"), (const
		uint8_t*)RESPON_OK, 500000, 0, NULL)))
		{
			//text mode
			if ((respons = sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT+CMGF=1\r"),
			(const uint8_t*)RESPON_OK, 500000, 0, NULL)))
			{
				//storage all to Sim card
				if ((respons = sim900_send_cmd_wait_reply(1,(const uint8_t*)
				PSTR("AT+CPMS=\"SM\",\"SM\",\"SM\"\r"), (const uint8_t*)RESPON_OK, 500000,
				0, NULL)))
				{
					//clip=1
					if ((respons = sim900_send_cmd_wait_reply(1,(const uint8_t*)
				PSTR("AT+CLIP=1\r"), (const uint8_t*)RESPON_OK, 500000, 0, NULL))){}
			}
		}
	}
}

//return it
return respons;
}

//send sms
uint8_t sim900_send_sms(const uint8_t *aSenderNumber, const uint8_t *aMessage)
{
  const uint8_t MAX_BUFFER = 32;
  uint8_t respon = 0/*, cmdx[MAX_BUFFER]*/;
  uint8_t *cmdx = (uint8_t*) calloc(MAX_BUFFER,sizeof(uint8_t));
  
  //buffer created???
  if (cmdx == NULL)
  {
	  return 0;
  }

  //build the string
  memset(cmdx, '\0', MAX_BUFFER);
  snprintf((char*)cmdx, MAX_BUFFER, "AT+CMGS=\"%s\"\r", aSenderNumber);

  if ((respon = sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const
    uint8_t*)">", 2000000, 0, NULL)))
  {
    //only copy MAX_BUFFER-2 char max from msg
    memcpy(&cmdx[0], aMessage, MAX_BUFFER - 2);
    cmdx[MAX_BUFFER - 2] = 0x1a;
    cmdx[MAX_BUFFER - 1] = 0x00;

    if ((respon = sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const
      uint8_t*)RESPON_OK, 10000000, 0, NULL))){}
  }
  
  //free buffer
  free(cmdx);

  return respon;
}

//calling a phone
uint8_t sim900_call_phone(const uint8_t *aSenderNumber)
{
  const uint8_t MAX_BUFFER = 30;
  uint8_t respon = 0/*, cmdx[MAX_BUFFER]*/;
  uint8_t *cmdx = (uint8_t*) calloc(MAX_BUFFER,sizeof(uint8_t));
  
  //buffer created?
  if (cmdx == NULL)
  {
	  return 0;
  }

  //init string
  memset(cmdx, '\0', MAX_BUFFER);
  snprintf((char*)cmdx, MAX_BUFFER, "ATD%s;\r", aSenderNumber);
  respon = sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const uint8_t*)
    RESPON_OK, 10000000, 0, NULL);
	
	//free buffer
	free(cmdx);
	
  return respon;
}

//cek gprs status
uint8_t sim900_gprs_is_opened()
{
  uint8_t respon = sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT+SAPBR=2,1\r"),
    (const uint8_t*)"1,1", 500000, 0, NULL);
  return respon;
}

//close gprs conn
uint8_t sim900_gprs_close_connection()
{
  //uint8_t respon = (sim900_gprs_is_opened() ? sim900_send_cmd_wait_reply((const
    //uint8_t*)"AT+SAPBR=0,1\r", (const uint8_t*)RESPON_OK, 5000000, 0, NULL): 1);
 uint8_t respon = (sim900_gprs_is_opened() ? sim900_send_cmd_wait_reply(1,(const
 uint8_t*)PSTR("AT+SAPBR=0,1\r"), (const uint8_t*)RESPON_OK, 5000000, 0, NULL): 1);
  return respon;
}

//open gprs conn
uint8_t sim900_gprs_start_connection()
{
  uint8_t respon = sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT+SAPBR=1,1\r"),
    (const uint8_t*)RESPON_OK, 100000000, 0, NULL);
  return respon;
}

//open gprs session
uint8_t sim900_gprs_open_connection(const uint8_t *apn, const uint8_t *username,
  const uint8_t *password)
{
  #define CMD_SAPBR_NEW	"AT+SAPBR=3,1,"

  const uint8_t MAX_BUFFER_NUM = 35;
  //uint8_t cmdx[MAX_BUFFER_NUM];
  uint8_t *cmdx = (uint8_t*) calloc(MAX_BUFFER_NUM,sizeof(uint8_t));
  
  //buffer created??
  if (cmdx == NULL)
  {
	  return 0;
  }

  //setup string
  memset(cmdx, '\0', MAX_BUFFER_NUM);

  //registered to network?
  if (!sim900_is_network_registered())
  {
	  free(cmdx);
    return 0;
  }

  //gprs already opened?
  if (sim900_gprs_is_opened())
  {
	  free(cmdx);
    return 1;
  }

  //init gprs connection
  snprintf((char*)cmdx, MAX_BUFFER_NUM, "%s\"CONTYPE\",\"GPRS\"\r",
    CMD_SAPBR_NEW);
  if (!sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const uint8_t*)
    RESPON_OK, 1000000, 0, NULL))
  {
	  free(cmdx);
    return 0;
  }

  //set apn
  snprintf((char*)cmdx, MAX_BUFFER_NUM, "%s\"APN\",\"%s\"\r", CMD_SAPBR_NEW,
    apn);
  if (!sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const uint8_t*)
    RESPON_OK, 1000000, 0, NULL))
  {
	  free(cmdx);
    return 0;
  }

  //set username
  snprintf((char*)cmdx, MAX_BUFFER_NUM, "%s\"USER\",\"%s\"\r", CMD_SAPBR_NEW,
    username);
  if (!sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const uint8_t*)
    RESPON_OK, 1000000, 0, NULL))
  {
	  free(cmdx);
    return 0;
  }

  //set passwd
  snprintf((char*)cmdx, MAX_BUFFER_NUM, "%s\"PWD\",\"%s\"\r", CMD_SAPBR_NEW,
    password);
  if (!sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const uint8_t*)
    RESPON_OK, 1000000, 0, NULL))
  {
	  free(cmdx);
    return 0;
  }

  //open gprs connection
  if (!sim900_gprs_start_connection())
  {
	  free(cmdx);
    return 0;
  }

	//free buffer
	free(cmdx);
	
  //return the respon
  return 1;
}

//terminate http session
uint8_t sim900_http_terminate()
{
  return sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT+HTTPTERM\r"), (const
    uint8_t*)RESPON_OK, 5000000, 0, NULL);
}

/*
//send http get
uint8_t sim900_http_get(const uint8_t *aurl, const uint8_t *adata, const uint8_t max_out_len,
  uint8_t*arespon_out)
{
  #define HTTP_PARA_URL "AT+HTTPPARA=\"URL\","
  const uint8_t MAX_BUFFER = 100;
  uint8_t cmdx[MAX_BUFFER], respon = 0;
  uint16_t num_data = 0;

  //set init result
  if (arespon_out != NULL)
  {
    memset(arespon_out, '\0', max_out_len *sizeof(uint8_t));
  }

  //check is connected
  if (!sim900_gprs_is_opened())
  {
    return 0;
  }

  //http init
  if (!sim900_send_cmd_wait_reply((const uint8_t*)"AT+HTTPINIT\r", (const
    uint8_t*)RESPON_OK, 5000000, 0, NULL))
  {
    return 0;
  }

  //http parameter cid
  if (!sim900_send_cmd_wait_reply((const uint8_t*)"AT+HTTPPARA=\"CID\",1\r", 
    (const uint8_t*)RESPON_OK, 5000000, 0, NULL))
  {
    sim900_http_terminate();
    return 0;
  }

  //http parameter url
  memset(cmdx, '\0', MAX_BUFFER);
  snprintf((char*)cmdx, MAX_BUFFER, "%s\"%s?%s\"\r", HTTP_PARA_URL, aurl, adata);
  if (!sim900_send_cmd_wait_reply((const uint8_t*)cmdx, (const uint8_t*)
    RESPON_OK, 5000000, 0, NULL))
  {
    sim900_http_terminate();
    return 0;
  }

  //get it
  respon = sim900_send_cmd_wait_reply((const uint8_t*)"AT+HTTPACTION=0\r", 
    (const uint8_t*)"+HTTPACTION:0,200", 20000000, 0, NULL);

  //if respon=1 then get the rest of data as length of respons
  if (respon)
  {
    memset(cmdx, '\0', MAX_BUFFER);
    //uint8_t *cmm = (uint8_t*) calloc(MAX_BUFFER,sizeof(uint8_t));
    respon = sim900_send_cmd_wait_reply(NULL, (const uint8_t*)"\r", 1000000,
      MAX_BUFFER, cmdx);
    //free(cmm);

    if (respon)
    {
      //find \r on the data respons
      //cmdx form = ,[respon length]\r
      uint8_t *pr = (uint8_t*)memchr(cmdx, '\r', MAX_BUFFER);

      if (pr != NULL)
      {
        uint8_t clen[6];
        memset(clen, '\0', 6); //set all to 0
        memcpy(clen, &cmdx[1], pr - &cmdx[1]); //copy the data respon length
        num_data = atoi((const char*)clen); //convert to int
      }
      else
      {
        num_data = 0;
      }

      //just limit it
      if (num_data > max_out_len)
      {
        num_data = max_out_len;
      }

      //read the data respon
      if (num_data > 0)
      {
        //allocate memory
        //make sure a respon out is capable of receiveing it
        //beware that you must make sure that the usart rx buffer is capable of receiving it
        memset(cmdx, '\0', MAX_BUFFER);
        snprintf((char*)cmdx, MAX_BUFFER, "AT+HTTPREAD=0,%d\r", num_data);
        respon = sim900_send_cmd_wait_reply((const uint8_t*)cmdx, (const
          uint8_t*)"+HTTPREAD:", 5000000, 0, NULL);
        if (respon)
        {
          //get the rest of data
          memset(cmdx, '\0', MAX_BUFFER);
          respon = sim900_send_cmd_wait_reply(NULL, (const uint8_t*)"\r\nOK",
            1000000, MAX_BUFFER, cmdx);

          //filter out the respon and get clean data
          if (respon)
          {
            //find first \n position
            pr = (uint8_t*)memchr(cmdx, '\n', num_data *sizeof(uint8_t));

            //copy to result
            memcpy(arespon_out, pr + 1, num_data *sizeof(uint8_t));
          }
        }
      }
    }
  }

  //terminate
  sim900_http_terminate();

  return respon;
}

//send http get
uint8_t sim900_http_post(const uint8_t *aurl, const uint8_t *adata, const
  uint8_t max_out_len, uint8_t*arespon_out)
{
  #define HTTP_PARA_URL "AT+HTTPPARA=\"URL\","
  const uint8_t MAX_BUFFER = 100;
  uint8_t cmdx[MAX_BUFFER], respon = 0;
  uint16_t num_data = 0;

  //set init result
  if (arespon_out != NULL)
  {
    memset(arespon_out, '\0', max_out_len *sizeof(uint8_t));
  }

  //check is connected
  if (!sim900_gprs_is_opened())
  {
    return 0;
  }

  //http init
  if (!sim900_send_cmd_wait_reply((const uint8_t*)"AT+HTTPINIT\r", (const
    uint8_t*)RESPON_OK, 5000000, 0, NULL))
  {
    return 0;
  }

  //http parameter cid
  if (!sim900_send_cmd_wait_reply((const uint8_t*)"AT+HTTPPARA=\"CID\",1\r", 
    (const uint8_t*)RESPON_OK, 5000000, 0, NULL))
  {
    sim900_http_terminate();
    return 0;
  }

  //http parameter url
  memset(cmdx, '\0', MAX_BUFFER);
  snprintf((char*)cmdx, MAX_BUFFER, "%s\"%s\"\r", HTTP_PARA_URL, aurl);
  if (!sim900_send_cmd_wait_reply((const uint8_t*)cmdx, (const uint8_t*)
    RESPON_OK, 5000000, 0, NULL))
  {
    sim900_http_terminate();
    return 0;
  }

  //set content type
  if (!sim900_send_cmd_wait_reply((const uint8_t*)
    "AT+HTTPPARA=\"CONTENT\",\"application/x-www-form-urlencoded\"\r", (const
    uint8_t*)RESPON_OK, 5000000, 0, NULL))
  {
    sim900_http_terminate();
    return 0;
  }

  //http post data
  memset(cmdx, '\0', MAX_BUFFER);
  snprintf((char*)cmdx, MAX_BUFFER, "AT+HTTPDATA=%d,20000\r", strlen((const
    char*)adata));
  if (!sim900_send_cmd_wait_reply((const uint8_t*)cmdx, (const uint8_t*)
    "DOWNLOAD", 20000000, 0, NULL))
  {
    sim900_http_terminate();
    return 0;
  }

  //send the data
  if (!sim900_send_cmd_wait_reply((const uint8_t*)adata, (const uint8_t*)"OK",
    5000000, 0, NULL))
  {
    sim900_http_terminate();
    return 0;
  }

  //post it
  respon = sim900_send_cmd_wait_reply((const uint8_t*)"AT+HTTPACTION=1\r", 
    (const uint8_t*)"+HTTPACTION:1,200", 20000000, 0, NULL);

  //if respon=1 then get the rest of data as length of respons
  if (respon)
  {
    memset(cmdx, '\0', MAX_BUFFER);
    //uint8_t *cmm = (uint8_t*) calloc(MAX_BUFFER,sizeof(uint8_t));
    respon = sim900_send_cmd_wait_reply(NULL, (const uint8_t*)"\r", 1000000,
      MAX_BUFFER, cmdx);
    //free(cmm);

    if (respon)
    {
      //find \r on the data respons
      //cmdx form = ,[respon length]\r
      uint8_t *pr = (uint8_t*)memchr(cmdx, '\r', MAX_BUFFER);

      if (pr != NULL)
      {
        uint8_t clen[6];
        memset(clen, '\0', 6); //set all to 0
        memcpy(clen, &cmdx[1], pr - &cmdx[1]); //copy the data respon length
        num_data = atoi((const char*)clen); //convert to int
      }
      else
      {
        num_data = 0;
      }

      //just limit it
      if (num_data > max_out_len)
      {
        num_data = max_out_len;
      }

      //read the data respon
      if (num_data > 0)
      {
        //allocate memory
        //make sure a respon out is capable of receiveing it
        //beware that you must make sure that the usart rx buffer is capable of receiving it
        memset(cmdx, '\0', MAX_BUFFER);
        snprintf((char*)cmdx, MAX_BUFFER, "AT+HTTPREAD=0,%d\r", num_data);
        respon = sim900_send_cmd_wait_reply((const uint8_t*)cmdx, (const
          uint8_t*)"+HTTPREAD:", 5000000, 0, NULL);
        if (respon)
        {
          //get the rest of data
          memset(cmdx, '\0', MAX_BUFFER);
          respon = sim900_send_cmd_wait_reply(NULL, (const uint8_t*)"\r\nOK",
            1000000, MAX_BUFFER, cmdx);

          //filter out the respon and get clean data
          if (respon)
          {
            //find first \n position
            pr = (uint8_t*)memchr(cmdx, '\n', num_data *sizeof(uint8_t));

            //copy to result
            memcpy(arespon_out, pr + 1, num_data *sizeof(uint8_t));
          }
        }
      }
    }
  }

  //terminate
  sim900_http_terminate();

  return respon;
}
*/

//send http data with get or post method
//if not expecting any reply, set max_out_len=0 and *arespon_out=NULL
uint8_t sim900_http_send_data(const uint8_t method, const uint8_t *aurl, const uint8_t *adata, const  uint8_t max_out_len, uint8_t *arespon_out)
{
	#define HTTP_PARA_URL "AT+HTTPPARA=\"URL\","
	const uint8_t MAX_BUFFER = 100;
	uint8_t /*cmdx[MAX_BUFFER],*/ respon = 0;
	uint16_t num_data = 0;
	uint8_t *cmdx = (uint8_t*) calloc(MAX_BUFFER,sizeof(uint8_t));
	
	//buffer created?
	if (cmdx == NULL)
	{
		return 0;
	}

	//set init result
	if (arespon_out != NULL)
	{
		memset(arespon_out, '\0', max_out_len *sizeof(uint8_t));
	}

	//check is connected
	if (!sim900_gprs_is_opened())
	{
		free(cmdx);
		return 0;
	}
	
	//make sure previous http is terminated
	sim900_http_terminate();
	
	//http init
	_delay_ms(100);
	if (!sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT+HTTPINIT\r"), (const
	uint8_t*)RESPON_OK, 5000000, 0, NULL))
	{
		free(cmdx);
		return 0;
	}

	//http parameter cid
	if (!sim900_send_cmd_wait_reply(1,(const uint8_t*)PSTR("AT+HTTPPARA=\"CID\",1\r"),
	(const uint8_t*)RESPON_OK, 5000000, 0, NULL))
	{
		sim900_http_terminate();
		free(cmdx);
		return 0;
	}

	//http parameter url
	memset(cmdx, '\0', MAX_BUFFER);
	//snprintf((char*)cmdx, MAX_BUFFER, (method ? "%s\"%s\"\r":"%s\"%s?%s\"\r"), HTTP_PARA_URL, aurl,(method ? ((char*)""):adata));
	if (method) //post
	{
		snprintf((char*)cmdx, MAX_BUFFER, "%s\"%s\"\r", HTTP_PARA_URL, aurl);
	} 
	else //get
	{
		snprintf((char*)cmdx, MAX_BUFFER, "%s\"%s?%s\"\r", HTTP_PARA_URL, aurl, adata);
	}
	if (!sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const uint8_t*)
	RESPON_OK, 5000000, 0, NULL))
	{
		sim900_http_terminate();
		free(cmdx);
		return 0;
	}

	//set content type for post only
	if(method)
	{
		if (!sim900_send_cmd_wait_reply(1,(const uint8_t*)
		PSTR("AT+HTTPPARA=\"CONTENT\",\"application/x-www-form-urlencoded\"\r"), (const
		uint8_t*)RESPON_OK, 5000000, 0, NULL))
		{
			sim900_http_terminate();
			free(cmdx);
			return 0;
		}
		
		//http post data
		memset(cmdx, '\0', MAX_BUFFER);
		snprintf((char*)cmdx, MAX_BUFFER, "AT+HTTPDATA=%d,20000\r", strlen((const
		char*)adata));
		if (!sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const uint8_t*)
		"DOWNLOAD", 20000000, 0, NULL))
		{
			sim900_http_terminate();
			free(cmdx);
			return 0;
		}

		//send the data
		if (!sim900_send_cmd_wait_reply(0,(const uint8_t*)adata, (const uint8_t*)"OK",
		5000000, 0, NULL))
		{
			sim900_http_terminate();
			free(cmdx);
			return 0;
		}
	}

	//send it
	respon = sim900_send_cmd_wait_reply(1,(const uint8_t*)(method ? PSTR("AT+HTTPACTION=1\r"):PSTR("AT+HTTPACTION=0\r")),
	(const uint8_t*)(method ? "+HTTPACTION:1,200":"+HTTPACTION:0,200"), 20000000, 0, NULL);

	//if respon=1 then get the rest of data as length of respons
	if (respon)
	{
		memset(cmdx, '\0', MAX_BUFFER);
		//uint8_t *cmm = (uint8_t*) calloc(MAX_BUFFER,sizeof(uint8_t));
		respon = sim900_send_cmd_wait_reply(0,NULL, (const uint8_t*)"\r", 1000000,
		MAX_BUFFER, cmdx);
		//free(cmm);

		if (respon)
		{
			//find \r on the data respons
			//cmdx form = ,[respon length]\r
			uint8_t *pr = (uint8_t*)memchr(cmdx, '\r', MAX_BUFFER);

			num_data = 0;
			if (pr != NULL)
			{
				uint8_t clen[6];
				memset(clen, '\0', 6); //set all to 0
				memcpy(clen, &cmdx[1], pr - &cmdx[1]); //copy the data respon length
				num_data = atoi((const char*)clen); //convert to int
			}

			//just limit it
			if (num_data > max_out_len)
			{
				num_data = max_out_len;
			}

			//read the data respon
			if (num_data > 0)
			{
				//allocate memory
				//make sure a respon out is capable of receiveing it
				//beware that you must make sure that the usart rx buffer is capable of receiving it
				memset(cmdx, '\0', MAX_BUFFER);
				snprintf((char*)cmdx, MAX_BUFFER, "AT+HTTPREAD=0,%d\r", num_data);
				respon = sim900_send_cmd_wait_reply(0,(const uint8_t*)cmdx, (const
				uint8_t*)"+HTTPREAD:", 5000000, 0, NULL);
				if (respon)
				{
					//get the rest of data
					memset(cmdx, '\0', MAX_BUFFER);
					respon = sim900_send_cmd_wait_reply(0,NULL, (const uint8_t*)"\r\nOK",
					1000000, MAX_BUFFER, cmdx);

					//filter out the respon and get clean data
					if (respon)
					{
						//find first \n position
						pr = (uint8_t*)memchr(cmdx, '\n', num_data *sizeof(uint8_t));

						//copy to result
						memcpy(arespon_out, pr + 1, num_data *sizeof(uint8_t));
					}
				}
			}
		}
	}

	//terminate
	sim900_http_terminate();
	
	//free buffer
	free(cmdx);

	return respon;
}

//main program
int main(void)
{
  //var
  uint8_t answer;
  uint8_t http_respon_data[64];

  //init pa sbg in
  DDRA = 0;
  PORTA = 0xff;

  //init lcd
  LCDinit();

  LCDclr();
  LCDcursorOFF();
  LCDhome();
  //fprintf(&LCDInputOutputStream,"HELLO WORLD");

  //init uart
  uart_init(UART_BAUD_SELECT(USART_BAUD_RATE, F_CPU));

  //enable isr
  sei();

  LCDGotoXY(0, 0);
  fprintf(&LCDInputOutputStream, "setup modem = %d", sim900_setup(1));
  _delay_ms(1000);

  //wait modem wake up
  //sim900_setup(1);

  //LCDclr();LCDhome();fprintf(&LCDInputOutputStream,"SMS");
  //
  //answer = sim900_send_sms((const uint8_t*)"087897781037",(const uint8_t*)"ini dari sim900");
  //fprintf(&LCDInputOutputStream,"=%d", answer);

  //main loop
  while (1)
  {
    //tes
    //answer = sim900_send_cmd_wait_reply((const uint8_t*)"AT\r",(const uint8_t*)"OK",5000000);
    //LCDGotoXY(0,0);
    //fprintf(&LCDInputOutputStream,"%3d", answer);
    //_delay_ms(500);

    //krm sms pa0
    if (bit_is_clear(PINA, PA0))
    {
      _delay_ms(100);
      loop_until_bit_is_set(PINA, PA0);

      //LCDclr();LCDhome();
      //fprintf(&LCDInputOutputStream,"krm sms = %d",
      //sim900_send_sms((const uint8_t*)"087897781037", (const uint8_t*)"pesan ini dikirim dari sim900 :)")
      //);
      LCDclr();
      LCDhome();
      fprintf(&LCDInputOutputStream, "open gprs = %d", sim900_gprs_open_connection(
        (const uint8_t*)"internet", (const uint8_t*)" ", (const uint8_t*)" "));
    }

    //calling
    //if (bit_is_clear(PINA, PA1))
    //{
    //_delay_ms(100);
    //loop_until_bit_is_set(PINA, PA1);
    //
    //LCDclr();LCDhome();
    //fprintf(&LCDInputOutputStream,"call = %d",
    //sim900_call_phone((const uint8_t*)"087897781037")
    //);
    //}

    //open gprs
    if (bit_is_clear(PINA, PA1))
    {
      _delay_ms(100);
      loop_until_bit_is_set(PINA, PA1);

      //answer = sim900_gprs_open_bearer((const uint8_t*)"internet", (const uint8_t*)" ", (const uint8_t*)" ");
      //answer = sim900_gprs_open_bearer("internet", " ", " ");
      //answer = sim900_gprs_is_opened();
      //answer = sim900_gprs_closed();
      //answer = sim900_http_get((const uint8_t*)
      //"http://ex4-tech.id.or.id/sim900/data.php", (const uint8_t*)"c=1", 64,
      //http_respon_data);
      answer = sim900_http_send_data(
	  HTTP_POST, 
	  (const uint8_t*)"http://ex4-tech.id.or.id/sim900/data.php", 
	  (const uint8_t*)"c=1", 
	  64,
        http_respon_data);
      LCDclr();
      LCDhome();
      fprintf(&LCDInputOutputStream, "post = %d", answer);
      LCDGotoXY(0, 1);
      fprintf(&LCDInputOutputStream, "%s", http_respon_data);
      _delay_ms(5000);
    }


    if (bit_is_clear(PINA, PA2))
    {
      _delay_ms(100);
      loop_until_bit_is_set(PINA, PA2);

      answer = sim900_gprs_close_connection();
      LCDclr();
      LCDhome();
      fprintf(&LCDInputOutputStream, "close gprs = %d", answer);
    }
  }
}
