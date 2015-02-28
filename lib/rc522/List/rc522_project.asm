
;CodeVisionAVR C Compiler V2.05.6 
;(C) Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 12.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x4E,0x4F,0x20,0x52,0x45,0x41,0x44,0x45
	.DB  0x52,0xA,0x0,0x52,0x43,0x35,0x32,0x32
	.DB  0x20,0x54,0x45,0x53,0x54,0xA,0x0,0x52
	.DB  0x43,0x35,0x32,0x32,0x20,0x44,0x45,0x54
	.DB  0x45,0x43,0x54,0x45,0x44,0xA,0x0,0x25
	.DB  0x2E,0x32,0x58,0x25,0x2E,0x32,0x58,0x25
	.DB  0x2E,0x32,0x58,0x25,0x2E,0x32,0x58,0x25
	.DB  0x2E,0x32,0x58,0x20,0x25,0x2E,0x34,0x58
	.DB  0xA,0x0,0x73,0x65,0x6C,0x65,0x63,0x74
	.DB  0x20,0x3D,0x20,0x25,0x2E,0x32,0x58,0xA
	.DB  0x0,0x6C,0x6F,0x67,0x69,0x6E,0x20,0x3D
	.DB  0x20,0x25,0x64,0xA,0x0,0x72,0x65,0x61
	.DB  0x64,0x20,0x3D,0x20,0x25,0x64,0x20,0x20
	.DB  0x25,0x2E,0x32,0x58,0x20,0x25,0x2E,0x32
	.DB  0x58,0x20,0x25,0x2E,0x32,0x58,0xA,0x0
_0x40003:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x40004:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _keyA_default
	.DW  _0x40003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.6
;Automatic Program Generator
;� Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : RC522
;Version : 1
;Date    : 2/27/2015
;Author  : EX4
;Company : EX4 TECH
;Comments:
;RC522 RFID READER WRITER
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;// avr lib
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <string.h>
;
;// spi lib
;#include <spix.h>
;
;// rc522 lib
;#include <mfrc522.h>
;
;// mode debug
;#define DEBUG_ON
;
;
;/*
;usart setup for debugging at 8-N-1-9600bps-No Parity
;*/
;void usart_init(void)
; 0000 002F {

	.CSEG
_usart_init:
; 0000 0030     UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0031     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0032     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0033     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0034     UBRRL=0x4D;
	LDI  R30,LOW(77)
	OUT  0x9,R30
; 0000 0035 }
	RET
;
;/*
;check rc522 rfid reader writer presence
;*/
;void rc522_check_reader()
; 0000 003B {
_rc522_check_reader:
; 0000 003C 	uint8_t curr_read_status = mfrc522_get_version();
; 0000 003D 	if (curr_read_status<0x90 || curr_read_status>0x92)
	ST   -Y,R17
;	curr_read_status -> R17
	CALL _mfrc522_get_version
	MOV  R17,R30
	CPI  R17,144
	BRLO _0x4
	CPI  R17,147
	BRLO _0x3
_0x4:
; 0000 003E 	{
; 0000 003F         #if defined(DEBUG_ON)
; 0000 0040 		    printf("NO READER\n");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x0
; 0000 0041         #endif
; 0000 0042 		for(;;);
_0x7:
	RJMP _0x7
; 0000 0043 	}
; 0000 0044 }
_0x3:
	JMP  _0x2060006
;
;/*
;read card serial id
;*/
;uint8_t rc522_read_card_id(uint8_t *card_id, uint16_t *card_type)
; 0000 004A {
_rc522_read_card_id:
; 0000 004B 	uint8_t status, resx = 0;
; 0000 004C 	uint8_t buff_data[MAX_LEN];
; 0000 004D 
; 0000 004E     *card_type = 0;
	CALL SUBOPT_0x1
	ST   -Y,R16
;	*card_id -> Y+20
;	*card_type -> Y+18
;	status -> R17
;	resx -> R16
;	buff_data -> Y+2
	LDI  R16,0
	CALL SUBOPT_0x2
; 0000 004F 	if(mfrc522_is_card(card_type))
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL _mfrc522_is_card
	CPI  R30,0
	BREQ _0x9
; 0000 0050 	{
; 0000 0051 		status = mfrc522_get_card_serial(buff_data);
	MOVW R26,R28
	ADIW R26,2
	CALL _mfrc522_get_card_serial
	MOV  R17,R30
; 0000 0052 		if (status==CARD_FOUND)
	CPI  R17,1
	BRNE _0xA
; 0000 0053 		{
; 0000 0054 			memcpy(card_id,buff_data,5);//kopi id and checksum at last byte (5th)
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _memcpy
; 0000 0055 			resx = 1;
	LDI  R16,LOW(1)
; 0000 0056 		}
; 0000 0057 		else
	RJMP _0xB
_0xA:
; 0000 0058 		{
; 0000 0059 			resx = 0;
	LDI  R16,LOW(0)
; 0000 005A 		}
_0xB:
; 0000 005B 	}
; 0000 005C 	else
	RJMP _0xC
_0x9:
; 0000 005D 	{
; 0000 005E 		resx = 0;
	LDI  R16,LOW(0)
; 0000 005F 	}
_0xC:
; 0000 0060 
; 0000 0061 	return resx;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,22
	RET
; 0000 0062 }
;
;/*
;  main program
;*/
;void main(void)
; 0000 0068 {
_main:
; 0000 0069     //local var
; 0000 006A     uint8_t curr_id[5];
; 0000 006B     uint16_t card_tipe;
; 0000 006C     uint8_t str[MAX_LEN];
; 0000 006D     uint8_t status;
; 0000 006E 
; 0000 006F     //start up delay
; 0000 0070     delay_ms(1000);
	SBIW R28,21
;	curr_id -> Y+16
;	card_tipe -> R16,R17
;	str -> Y+0
;	status -> R19
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0071 
; 0000 0072     //init usart
; 0000 0073     usart_init();
	RCALL _usart_init
; 0000 0074 
; 0000 0075     #if defined(DEBUG_ON)
; 0000 0076     printf("RC522 TEST\n");
	__POINTW1FN _0x0,11
	CALL SUBOPT_0x0
; 0000 0077     #endif
; 0000 0078 
; 0000 0079     // init spi as master
; 0000 007A     spi_init();
	RCALL _spi_init
; 0000 007B 
; 0000 007C     // init rc522
; 0000 007D     mfrc522_init();
	CALL _mfrc522_init
; 0000 007E 
; 0000 007F     // check reader attached???
; 0000 0080     rc522_check_reader();
	RCALL _rc522_check_reader
; 0000 0081 
; 0000 0082     #if defined(DEBUG_ON)
; 0000 0083     printf("RC522 DETECTED\n");
	__POINTW1FN _0x0,23
	CALL SUBOPT_0x0
; 0000 0084     #endif
; 0000 0085 
; 0000 0086     while (1)
_0xD:
; 0000 0087     {
; 0000 0088         // read id card
; 0000 0089         if (rc522_read_card_id(curr_id, &card_tipe))
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	RCALL _rc522_read_card_id
	POP  R16
	POP  R17
	CPI  R30,0
	BRNE PC+3
	JMP _0x10
; 0000 008A         {
; 0000 008B             printf("%.2X%.2X%.2X%.2X%.2X %.4X\n", curr_id[0], curr_id[1], curr_id[2], curr_id[3], curr_id[4], card_tipe);
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+18
	CALL SUBOPT_0x3
	LDD  R30,Y+23
	CALL SUBOPT_0x3
	LDD  R30,Y+28
	CALL SUBOPT_0x3
	LDD  R30,Y+33
	CALL SUBOPT_0x3
	LDD  R30,Y+38
	CALL SUBOPT_0x3
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,24
	CALL _printf
	ADIW R28,26
; 0000 008C 
; 0000 008D             // select the tag
; 0000 008E             printf("select = %.2X\n", mfrc522_select_tag(curr_id));
	__POINTW1FN _0x0,66
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,18
	CALL _mfrc522_select_tag
	CALL SUBOPT_0x3
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 008F 
; 0000 0090             //login to block 4
; 0000 0091             printf("login = %d\n", mfrc522_auth(PICC_AUTHENT1A, 4, keyA_default, curr_id));
	__POINTW1FN _0x0,81
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(96)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(_keyA_default)
	LDI  R31,HIGH(_keyA_default)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,22
	CALL _mfrc522_auth
	CALL SUBOPT_0x3
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 0092 
; 0000 0093             //read block 4
; 0000 0094             status = mfrc522_read_block(4, str);
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,1
	CALL _mfrc522_read_block
	MOV  R19,R30
; 0000 0095             printf("read = %d  %.2X %.2X %.2X\n", status, str[0], str[1], str[2]);
	__POINTW1FN _0x0,93
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R19
	CALL SUBOPT_0x3
	LDD  R30,Y+6
	CALL SUBOPT_0x3
	LDD  R30,Y+11
	CALL SUBOPT_0x3
	LDD  R30,Y+16
	CALL SUBOPT_0x3
	LDI  R24,16
	CALL _printf
	ADIW R28,18
; 0000 0096 
; 0000 0097 //            delay_ms(1000);
; 0000 0098 //
; 0000 0099 //            //login to block 4
; 0000 009A //            printf("login = %d\n", mfrc522_auth(PICC_AUTHENT1A, 4, keyA_default, curr_id));
; 0000 009B //
; 0000 009C //            //write block 4
; 0000 009D //            str[0] = 1;
; 0000 009E //            str[1] = 2;
; 0000 009F //            str[2] = 3;
; 0000 00A0 //            status = mfrc522_write_block(4, str);
; 0000 00A1 //
; 0000 00A2 //            delay_ms(1000);
; 0000 00A3 //
; 0000 00A4 //            //login to block 4
; 0000 00A5 //            printf("login = %d\n", mfrc522_auth(PICC_AUTHENT1A, 4, keyA_default, curr_id));
; 0000 00A6 //
; 0000 00A7 //            //read block 4
; 0000 00A8 //            status = mfrc522_read_block(4, str);
; 0000 00A9 //            printf("read = %d  %.2X %.2X %.2X\n", status, str[0], str[1], str[2]);
; 0000 00AA         }
; 0000 00AB 
; 0000 00AC         //halt the card
; 0000 00AD         mfrc522_halt();
_0x10:
	CALL _mfrc522_halt
; 0000 00AE 
; 0000 00AF         //delay
; 0000 00B0         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00B1 
; 0000 00B2         //eternal loop
; 0000 00B3 //        for(;;);
; 0000 00B4     }
	RJMP _0xD
; 0000 00B5 }
_0x11:
	RJMP _0x11
;/*
; * spi.c
; *
; * Copyright 2013 Shimon <shimon@monistit.com>
; *
; * This program is free software; you can redistribute it and/or modify
; * it under the terms of the GNU General Public License as published by
; * the Free Software Foundation; either version 2 of the License, or
; * (at your option) any later version.
; *
; * This program is distributed in the hope that it will be useful,
; * but WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; * GNU General Public License for more details.
; *
; * You should have received a copy of the GNU General Public License
; * along with this program; if not, write to the Free Software
; * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
; * MA 02110-1301, USA.
; *
; *
; */
;#include <spix.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#if SPI_CONFIG_AS_MASTER
;void spi_init()
; 0001 001B {

	.CSEG
_spi_init:
; 0001 001C 	SPI_DDR = (1<<SPI_MOSI)|(1<<SPI_SCK)|(1<<SPI_SS);
	LDI  R30,LOW(176)
	OUT  0x17,R30
; 0001 001D 	SPCR = (1<<SPE)|(1<<MSTR)|(1<<SPR0);//prescaler 16
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0001 001E }
	RET
;
;
;uint8_t spi_transmit(uint8_t data)
; 0001 0022 {
_spi_transmit:
; 0001 0023 	SPDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0001 0024 	while(!(SPSR & (1<<SPIF)));
_0x20003:
	SBIS 0xE,7
	RJMP _0x20003
; 0001 0025 
; 0001 0026 	return SPDR;
	IN   R30,0xF
	JMP  _0x2060002
; 0001 0027 }
;
;#else
;void spi_init()
;{
;	SPI_DDR = (1<<SPI_MISO);
;	SPCR = (1<<SPE);
;}
;
;uint8_t spi_transmit(uint8_t data)
;{
;	while(!(SPSR & (1<<SPIF)));
;	return SPDR;
;}
;#endif
;/*
; * mfrc522.c
; *
; * Copyright 2013 Shimon <shimon@monistit.com>
; *
; * This program is free software; you can redistribute it and/or modify
; * it under the terms of the GNU General Public License as published by
; * the Free Software Foundation; either version 2 of the License, or
; * (at your option) any later version.
; *
; * This program is distributed in the hope that it will be useful,
; * but WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; * GNU General Public License for more details.
; *
; * You should have received a copy of the GNU General Public License
; * along with this program; if not, write to the Free Software
; * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
; * MA 02110-1301, USA.
; *
; *
; */
;#include <mfrc522.h>
;#include <spix.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;//key default A and B
;uint8_t keyA_default[6] = {0xff,0xff,0xff,0xff,0xff,0xff};

	.DSEG
;uint8_t keyB_default[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
;
;/*
;initialize rc522
;*/
;void mfrc522_init()
; 0002 0022 {

	.CSEG
_mfrc522_init:
; 0002 0023 	uint8_t byte;
; 0002 0024 	mfrc522_reset();
	ST   -Y,R17
;	byte -> R17
	RCALL _mfrc522_reset
; 0002 0025 
; 0002 0026 	mfrc522_write(TModeReg, 0x8D);
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(141)
	RCALL _mfrc522_write
; 0002 0027     mfrc522_write(TPrescalerReg, 0x3E);
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(62)
	RCALL _mfrc522_write
; 0002 0028     mfrc522_write(TReloadReg_1, 30);
	LDI  R30,LOW(44)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _mfrc522_write
; 0002 0029     mfrc522_write(TReloadReg_2, 0);
	LDI  R30,LOW(45)
	CALL SUBOPT_0x4
; 0002 002A 	mfrc522_write(TxASKReg, 0x40);
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _mfrc522_write
; 0002 002B 	mfrc522_write(ModeReg, 0x3D);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(61)
	RCALL _mfrc522_write
; 0002 002C 
; 0002 002D     // antenna on
; 0002 002E 	byte = mfrc522_read(TxControlReg);
	LDI  R26,LOW(20)
	RCALL _mfrc522_read
	MOV  R17,R30
; 0002 002F 	if(!(byte&0x03))
	MOV  R30,R17
	ANDI R30,LOW(0x3)
	BRNE _0x40005
; 0002 0030 	{
; 0002 0031 		mfrc522_write(TxControlReg,byte|0x03);
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOV  R30,R17
	ORI  R30,LOW(0x3)
	MOV  R26,R30
	RCALL _mfrc522_write
; 0002 0032 	}
; 0002 0033 }
_0x40005:
_0x2060006:
	LD   R17,Y+
	RET
;
;/*
;write data to rc522 register
;*/
;void mfrc522_write(uint8_t reg, uint8_t data)
; 0002 0039 {
_mfrc522_write:
; 0002 003A 	ENABLE_CHIP();
	ST   -Y,R26
;	reg -> Y+1
;	data -> Y+0
	CBI  0x18,4
; 0002 003B 	spi_transmit((reg<<1)&0x7E);
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	MOV  R26,R30
	RCALL _spi_transmit
; 0002 003C 	spi_transmit(data);
	LD   R26,Y
	RCALL _spi_transmit
; 0002 003D 	DISABLE_CHIP();
	SBI  0x18,4
; 0002 003E }
	RJMP _0x2060005
;
;/*
;read data from rc522 register
;*/
;uint8_t mfrc522_read(uint8_t reg)
; 0002 0044 {
_mfrc522_read:
; 0002 0045 	uint8_t data;
; 0002 0046 	ENABLE_CHIP();
	ST   -Y,R26
	ST   -Y,R17
;	reg -> Y+1
;	data -> R17
	CBI  0x18,4
; 0002 0047 	spi_transmit(((reg<<1)&0x7E)|0x80);
	LDD  R30,Y+1
	LSL  R30
	ANDI R30,LOW(0x7E)
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _spi_transmit
; 0002 0048 	data = spi_transmit(0x00);
	LDI  R26,LOW(0)
	RCALL _spi_transmit
	MOV  R17,R30
; 0002 0049 	DISABLE_CHIP();
	SBI  0x18,4
; 0002 004A 	return data;
	MOV  R30,R17
	LDD  R17,Y+0
_0x2060005:
	ADIW R28,2
	RET
; 0002 004B }
;
;/*
;soft reset rc522
;*/
;void mfrc522_reset()
; 0002 0051 {
_mfrc522_reset:
; 0002 0052 	mfrc522_write(CommandReg,SoftReset_CMD);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _mfrc522_write
; 0002 0053 }
	RET
;
;/*
;make command request to rc522
;*/
;uint8_t	mfrc522_request(uint8_t req_mode, uint8_t * tag_type)
; 0002 0059 {
_mfrc522_request:
; 0002 005A 	uint8_t  status;
; 0002 005B 	uint32_t backBits;//The received data bits
; 0002 005C 
; 0002 005D 	mfrc522_write(BitFramingReg, 0x07);//TxLastBists = BitFramingReg[2..0]	???
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	req_mode -> Y+7
;	*tag_type -> Y+5
;	status -> R17
;	backBits -> Y+1
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _mfrc522_write
; 0002 005E 
; 0002 005F 	tag_type[0] = req_mode;
	LDD  R30,Y+7
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ST   X,R30
; 0002 0060 	status = mfrc522_to_card(Transceive_CMD, tag_type, 1, tag_type, &backBits);
	CALL SUBOPT_0x5
	LDI  R30,LOW(1)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0002 0061 
; 0002 0062 	if ((status != CARD_FOUND) || (backBits != 0x10))
	BRNE _0x40007
	__GETD2S 1
	__CPD2N 0x10
	BREQ _0x40006
_0x40007:
; 0002 0063 	{
; 0002 0064 		status = ERROR;
	LDI  R17,LOW(3)
; 0002 0065 	}
; 0002 0066 
; 0002 0067 	return status;
_0x40006:
	RJMP _0x2060004
; 0002 0068 }
;
;/*
;send command to rc522 to card
;*/
;uint8_t mfrc522_to_card(uint8_t cmd, uint8_t *send_data, uint8_t send_data_len, uint8_t *back_data, uint32_t *back_data_len)
; 0002 006E {
_mfrc522_to_card:
; 0002 006F 	uint8_t status = ERROR;
; 0002 0070     uint8_t irqEn = 0x00;
; 0002 0071     uint8_t waitIRq = 0x00;
; 0002 0072     uint8_t lastBits;
; 0002 0073     uint8_t n;
; 0002 0074     uint8_t	tmp;
; 0002 0075     uint32_t i;
; 0002 0076 
; 0002 0077     switch (cmd)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
;	cmd -> Y+17
;	*send_data -> Y+15
;	send_data_len -> Y+14
;	*back_data -> Y+12
;	*back_data_len -> Y+10
;	status -> R17
;	irqEn -> R16
;	waitIRq -> R19
;	lastBits -> R18
;	n -> R21
;	tmp -> R20
;	i -> Y+6
	LDI  R17,3
	LDI  R16,0
	LDI  R19,0
	LDD  R30,Y+17
	LDI  R31,0
; 0002 0078     {
; 0002 0079         case MFAuthent_CMD:		//Certification cards close
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x4000C
; 0002 007A 		{
; 0002 007B 			irqEn = 0x12;
	LDI  R16,LOW(18)
; 0002 007C 			waitIRq = 0x10;
	LDI  R19,LOW(16)
; 0002 007D 			break;
	RJMP _0x4000B
; 0002 007E 		}
; 0002 007F 		case Transceive_CMD:	//Transmit FIFO data
_0x4000C:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x4000E
; 0002 0080 		{
; 0002 0081 			irqEn = 0x77;
	LDI  R16,LOW(119)
; 0002 0082 			waitIRq = 0x30;
	LDI  R19,LOW(48)
; 0002 0083 			break;
; 0002 0084 		}
; 0002 0085 		default:
_0x4000E:
; 0002 0086 			break;
; 0002 0087     }
_0x4000B:
; 0002 0088 
; 0002 0089     //mfrc522_write(ComIEnReg, irqEn|0x80);	//Interrupt request
; 0002 008A     n=mfrc522_read(ComIrqReg);
	LDI  R26,LOW(4)
	RCALL _mfrc522_read
	MOV  R21,R30
; 0002 008B     mfrc522_write(ComIrqReg,n&(~0x80));//clear all interrupt bits
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOV  R30,R21
	ANDI R30,0x7F
	MOV  R26,R30
	RCALL _mfrc522_write
; 0002 008C     n=mfrc522_read(FIFOLevelReg);
	LDI  R26,LOW(10)
	RCALL _mfrc522_read
	MOV  R21,R30
; 0002 008D     mfrc522_write(FIFOLevelReg,n|0x80);//flush FIFO data
	LDI  R30,LOW(10)
	CALL SUBOPT_0x8
; 0002 008E 
; 0002 008F 	mfrc522_write(CommandReg, Idle_CMD);	//NO action; Cancel the current cmd???
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4
; 0002 0090 
; 0002 0091 	//Writing data to the FIFO
; 0002 0092     for (i=0; i<send_data_len; i++)
	LDI  R30,LOW(0)
	__CLRD1S 6
_0x40010:
	LDD  R30,Y+14
	CALL SUBOPT_0x9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x40011
; 0002 0093     {
; 0002 0094 		mfrc522_write(FIFODataReg, send_data[i]);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _mfrc522_write
; 0002 0095 	}
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	RJMP _0x40010
_0x40011:
; 0002 0096 
; 0002 0097 	//Execute the cmd
; 0002 0098 	mfrc522_write(CommandReg, cmd);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+18
	RCALL _mfrc522_write
; 0002 0099     if (cmd == Transceive_CMD)
	LDD  R26,Y+17
	CPI  R26,LOW(0xC)
	BRNE _0x40012
; 0002 009A     {
; 0002 009B 		n=mfrc522_read(BitFramingReg);
	LDI  R26,LOW(13)
	RCALL _mfrc522_read
	MOV  R21,R30
; 0002 009C 		mfrc522_write(BitFramingReg,n|0x80);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x8
; 0002 009D 	}
; 0002 009E 
; 0002 009F 	//Waiting to receive data to complete
; 0002 00A0 	i = 2000;	//i according to the clock frequency adjustment, the operator M1 card maximum waiting time 25ms???
_0x40012:
	__GETD1N 0x7D0
	__PUTD1S 6
; 0002 00A1     do
_0x40014:
; 0002 00A2     {
; 0002 00A3 		//CommIrqReg[7..0]
; 0002 00A4 		//Set1 TxIRq RxIRq IdleIRq HiAlerIRq LoAlertIRq ErrIRq TimerIRq
; 0002 00A5         n = mfrc522_read(ComIrqReg);
	LDI  R26,LOW(4)
	RCALL _mfrc522_read
	MOV  R21,R30
; 0002 00A6         i--;
	CALL SUBOPT_0xA
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 6
; 0002 00A7     }
; 0002 00A8     while ((i!=0) && !(n&0x01) && !(n&waitIRq));
	CALL SUBOPT_0x9
	CALL __CPD02
	BREQ _0x40016
	SBRC R21,0
	RJMP _0x40016
	MOV  R30,R19
	AND  R30,R21
	BREQ _0x40017
_0x40016:
	RJMP _0x40015
_0x40017:
	RJMP _0x40014
_0x40015:
; 0002 00A9 
; 0002 00AA 	tmp=mfrc522_read(BitFramingReg);
	LDI  R26,LOW(13)
	RCALL _mfrc522_read
	MOV  R20,R30
; 0002 00AB 	mfrc522_write(BitFramingReg,tmp&(~0x80));
	LDI  R30,LOW(13)
	ST   -Y,R30
	MOV  R30,R20
	ANDI R30,0x7F
	MOV  R26,R30
	RCALL _mfrc522_write
; 0002 00AC 
; 0002 00AD     if (i != 0)
	CALL SUBOPT_0xA
	CALL __CPD10
	BRNE PC+3
	JMP _0x40018
; 0002 00AE     {
; 0002 00AF         if(!(mfrc522_read(ErrorReg) & 0x1B))	//BufferOvfl Collerr CRCErr ProtecolErr
	LDI  R26,LOW(6)
	RCALL _mfrc522_read
	ANDI R30,LOW(0x1B)
	BREQ PC+3
	JMP _0x40019
; 0002 00B0         {
; 0002 00B1             status = CARD_FOUND;
	LDI  R17,LOW(1)
; 0002 00B2             if (n & irqEn & 0x01)
	MOV  R30,R16
	AND  R30,R21
	ANDI R30,LOW(0x1)
	BREQ _0x4001A
; 0002 00B3             {
; 0002 00B4 				status = CARD_NOT_FOUND;			//??
	LDI  R17,LOW(2)
; 0002 00B5 			}
; 0002 00B6 
; 0002 00B7             if (cmd == Transceive_CMD)
_0x4001A:
	LDD  R26,Y+17
	CPI  R26,LOW(0xC)
	BREQ PC+3
	JMP _0x4001B
; 0002 00B8             {
; 0002 00B9                	n = mfrc522_read(FIFOLevelReg);
	LDI  R26,LOW(10)
	RCALL _mfrc522_read
	MOV  R21,R30
; 0002 00BA               	lastBits = mfrc522_read(ControlReg) & 0x07;
	LDI  R26,LOW(12)
	RCALL _mfrc522_read
	ANDI R30,LOW(0x7)
	MOV  R18,R30
; 0002 00BB                 if (lastBits)
	CPI  R18,0
	BREQ _0x4001C
; 0002 00BC                 {
; 0002 00BD 					*back_data_len = (uint32_t)(n-1)*8 + (uint32_t)lastBits;
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,1
	CALL SUBOPT_0xC
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R18
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD12
	RJMP _0x40050
; 0002 00BE 				}
; 0002 00BF                 else
_0x4001C:
; 0002 00C0                 {
; 0002 00C1 					*back_data_len = (uint32_t)n*8;
	MOV  R30,R21
	LDI  R31,0
	CALL SUBOPT_0xC
_0x40050:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __PUTDP1
; 0002 00C2 				}
; 0002 00C3 
; 0002 00C4                 if (n == 0)
	CPI  R21,0
	BRNE _0x4001E
; 0002 00C5                 {
; 0002 00C6 					n = 1;
	LDI  R21,LOW(1)
; 0002 00C7 				}
; 0002 00C8                 if (n > MAX_LEN)
_0x4001E:
	CPI  R21,17
	BRLO _0x4001F
; 0002 00C9                 {
; 0002 00CA 					n = MAX_LEN;
	LDI  R21,LOW(16)
; 0002 00CB 				}
; 0002 00CC 
; 0002 00CD 				//Reading the received data in FIFO
; 0002 00CE                 for (i=0; i<n; i++)
_0x4001F:
	LDI  R30,LOW(0)
	__CLRD1S 6
_0x40021:
	MOV  R30,R21
	CALL SUBOPT_0x9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x40022
; 0002 00CF                 {
; 0002 00D0 					back_data[i] = mfrc522_read(FIFODataReg);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(9)
	RCALL _mfrc522_read
	POP  R26
	POP  R27
	ST   X,R30
; 0002 00D1 				}
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	RJMP _0x40021
_0x40022:
; 0002 00D2             }
; 0002 00D3         }
_0x4001B:
; 0002 00D4         else
	RJMP _0x40023
_0x40019:
; 0002 00D5         {
; 0002 00D6 			status = ERROR;
	LDI  R17,LOW(3)
; 0002 00D7 		}
_0x40023:
; 0002 00D8 
; 0002 00D9     }
; 0002 00DA 
; 0002 00DB     //SetBitMask(ControlReg,0x80);           //timer stops
; 0002 00DC     //mfrc522_write(cmdReg, PCD_IDLE);
; 0002 00DD 
; 0002 00DE     return status;
_0x40018:
	MOV  R30,R17
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; 0002 00DF }
;
;/*
;get card serial
;*/
;uint8_t mfrc522_get_card_serial(uint8_t * serial_out)
; 0002 00E5 {
_mfrc522_get_card_serial:
; 0002 00E6 	uint8_t status;
; 0002 00E7     uint8_t i;
; 0002 00E8 	uint8_t serNumCheck=0;
; 0002 00E9     uint32_t unLen;
; 0002 00EA 
; 0002 00EB 	mfrc522_write(BitFramingReg, 0x00);		//TxLastBists = BitFramingReg[2..0]
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
;	*serial_out -> Y+8
;	status -> R17
;	i -> R16
;	serNumCheck -> R19
;	unLen -> Y+4
	LDI  R19,0
	LDI  R30,LOW(13)
	CALL SUBOPT_0x4
; 0002 00EC 
; 0002 00ED     serial_out[0] = PICC_ANTICOLL;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(147)
	ST   X,R30
; 0002 00EE     serial_out[1] = 0x20;
	ADIW R26,1
	LDI  R30,LOW(32)
	ST   X,R30
; 0002 00EF     status = mfrc522_to_card(Transceive_CMD, serial_out, 2, serial_out, &unLen);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x6
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL _mfrc522_to_card
	MOV  R17,R30
; 0002 00F0 
; 0002 00F1     if (status == CARD_FOUND)
	CPI  R17,1
	BRNE _0x40024
; 0002 00F2 	{
; 0002 00F3 		//Check card serial number
; 0002 00F4 		for (i=0; i<4; i++)
	LDI  R16,LOW(0)
_0x40026:
	CPI  R16,4
	BRSH _0x40027
; 0002 00F5 		{
; 0002 00F6 		 	serNumCheck ^= serial_out[i];
	CALL SUBOPT_0xD
	EOR  R19,R30
; 0002 00F7 		}
	SUBI R16,-1
	RJMP _0x40026
_0x40027:
; 0002 00F8 		if (serNumCheck != serial_out[i])
	CALL SUBOPT_0xD
	CP   R30,R19
	BREQ _0x40028
; 0002 00F9 		{
; 0002 00FA 			status = ERROR;
	LDI  R17,LOW(3)
; 0002 00FB 		}
; 0002 00FC     }
_0x40028:
; 0002 00FD     return status;
_0x40024:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,10
	RET
; 0002 00FE }
;
;/*
;set bit mask
;*/
;void mfrc522_setBitMask(uint8_t reg, uint8_t mask)
; 0002 0104 {
_mfrc522_setBitMask:
; 0002 0105 	uint8_t tmp;
; 0002 0106 	tmp = mfrc522_read(reg);
	CALL SUBOPT_0xE
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
; 0002 0107 	mfrc522_write(reg, tmp | mask);  // set bit mask
	LDD  R26,Y+2
	OR   R26,R17
	RCALL _mfrc522_write
; 0002 0108 }
	LDD  R17,Y+0
	JMP  _0x2060001
;
;/*
;clear bit mask
;*/
;void mfrc522_clearBitMask(uint8_t reg, uint8_t mask)
; 0002 010E {
_mfrc522_clearBitMask:
; 0002 010F 	uint8_t tmp;
; 0002 0110 	tmp = mfrc522_read(reg);
	CALL SUBOPT_0xE
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
; 0002 0111 	mfrc522_write(reg, tmp & (~mask));  // clear bit mask
	LDD  R30,Y+2
	COM  R30
	AND  R30,R17
	MOV  R26,R30
	RCALL _mfrc522_write
; 0002 0112 }
	LDD  R17,Y+0
	JMP  _0x2060001
;
;/*
;calculate crc using rc522 chip
;*/
;void mfrc522_calculateCRC(uint8_t *pIndata, uint8_t len, uint8_t *pOutData)
; 0002 0118 {
_mfrc522_calculateCRC:
; 0002 0119 	uint8_t i, n;
; 0002 011A 
; 0002 011B 	mfrc522_clearBitMask(DivIrqReg, 0x04);			//CRCIrq = 0
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pIndata -> Y+5
;	len -> Y+4
;	*pOutData -> Y+2
;	i -> R17
;	n -> R16
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _mfrc522_clearBitMask
; 0002 011C 	mfrc522_setBitMask(FIFOLevelReg, 0x80);			//Claro puntero FIFO
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _mfrc522_setBitMask
; 0002 011D 	//Write_MFRC522(CommandReg, PCD_IDLE);
; 0002 011E 
; 0002 011F 	//Escribir datos en el FIFO
; 0002 0120 	for (i=0; i<len; i++)
	LDI  R17,LOW(0)
_0x4002A:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0x4002B
; 0002 0121 	{
; 0002 0122 		mfrc522_write(FIFODataReg, *(pIndata+i));
	LDI  R30,LOW(9)
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _mfrc522_write
; 0002 0123 	}
	SUBI R17,-1
	RJMP _0x4002A
_0x4002B:
; 0002 0124 	mfrc522_write(CommandReg, PCD_CALCCRC);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _mfrc522_write
; 0002 0125 
; 0002 0126 	// Esperar a la finalizaciÃ³n de cÃ¡lculo del CRC
; 0002 0127 	i = 0xFF;
	LDI  R17,LOW(255)
; 0002 0128 	do
_0x4002D:
; 0002 0129 	{
; 0002 012A 		n = mfrc522_read(DivIrqReg);
	LDI  R26,LOW(5)
	RCALL _mfrc522_read
	MOV  R16,R30
; 0002 012B 		i--;
	SUBI R17,1
; 0002 012C 	}
; 0002 012D 	while ((i!=0) && !(n&0x04));			//CRCIrq = 1
	CPI  R17,0
	BREQ _0x4002F
	SBRS R16,2
	RJMP _0x40030
_0x4002F:
	RJMP _0x4002E
_0x40030:
	RJMP _0x4002D
_0x4002E:
; 0002 012E 
; 0002 012F 	//Lea el cÃ¡lculo de CRC
; 0002 0130 	pOutData[0] = mfrc522_read(CRCResultReg_2);
	LDI  R26,LOW(34)
	RCALL _mfrc522_read
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
; 0002 0131 	pOutData[1] = mfrc522_read(CRCResultReg_1);
	LDI  R26,LOW(33)
	RCALL _mfrc522_read
	__PUTB1SNS 2,1
; 0002 0132 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
;
;/*
;halt the card (release it to be able to read again)
;*/
;uint8_t mfrc522_halt()
; 0002 0138 {
_mfrc522_halt:
; 0002 0139 	uint8_t status;
; 0002 013A 	uint32_t unLen;
; 0002 013B 	uint8_t buff[4];
; 0002 013C 
; 0002 013D 	buff[0] = PICC_HALT;
	SBIW R28,8
	ST   -Y,R17
;	status -> R17
;	unLen -> Y+5
;	buff -> Y+1
	LDI  R30,LOW(80)
	STD  Y+1,R30
; 0002 013E 	buff[1] = 0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
; 0002 013F 	mfrc522_calculateCRC(buff, 2, &buff[2]);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	RCALL _mfrc522_calculateCRC
; 0002 0140 
; 0002 0141 	mfrc522_clearBitMask(Status2Reg, 0x08); // turn off encryption
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _mfrc522_clearBitMask
; 0002 0142 
; 0002 0143 	status = mfrc522_to_card(Transceive_CMD, buff, 4, buff,&unLen);
	LDI  R30,LOW(12)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,11
	RCALL _mfrc522_to_card
	MOV  R17,R30
; 0002 0144 
; 0002 0145 	return status;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,9
	RET
; 0002 0146 }
;
;/*
;get reader version
;*/
;uint8_t mfrc522_get_version()
; 0002 014C {
_mfrc522_get_version:
; 0002 014D 	return mfrc522_read(VersionReg);
	LDI  R26,LOW(55)
	RCALL _mfrc522_read
	RET
; 0002 014E }
;
;/*
;check if card is in range
;*/
;uint8_t mfrc522_is_card(uint16_t *card_type)
; 0002 0154 {
_mfrc522_is_card:
; 0002 0155 	uint8_t buff_data[MAX_LEN],
; 0002 0156     status = mfrc522_request(PICC_REQIDL,buff_data);
; 0002 0157     if(status == CARD_FOUND){
	CALL SUBOPT_0x1
;	*card_type -> Y+17
;	buff_data -> Y+1
;	status -> R17
	LDI  R30,LOW(38)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _mfrc522_request
	MOV  R17,R30
	CPI  R17,1
	BRNE _0x40031
; 0002 0158         *card_type = (buff_data[0]<<8)+buff_data[1];
	LDI  R30,0
	LDD  R31,Y+1
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ST   X+,R30
	ST   X,R31
; 0002 0159         return 1;
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	RJMP _0x2060003
; 0002 015A     }
; 0002 015B     else{
_0x40031:
; 0002 015C         return 0;
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2060003
; 0002 015D     }
; 0002 015E }
;
;/*
; * Function Name : MFRC522_Auth
; * Description : Verify card password
; * Input parameters : authMode - Password Authentication Mode
;                 0x60 = A key authentication
;                 0x61 = B key authentication
;             BlockAddr - block address
;             Sectorkey - Sector password
;             serNum - card serial number, 4-byte
; * Return value: the successful return CARD_FOUND
; */
;uint8_t mfrc522_auth(uint8_t authMode, uint8_t BlockAddr, uint8_t *Sectorkey, uint8_t *serNum)
; 0002 016C {
_mfrc522_auth:
; 0002 016D     uint8_t status;
; 0002 016E     uint32_t recvBits;
; 0002 016F     uint8_t i;
; 0002 0170 	uint8_t buff[12];
; 0002 0171 
; 0002 0172     // Validate instruction block address + sector + password + card serial number
; 0002 0173     buff[0] = authMode;
	CALL SUBOPT_0x1
	ST   -Y,R16
;	authMode -> Y+23
;	BlockAddr -> Y+22
;	*Sectorkey -> Y+20
;	*serNum -> Y+18
;	status -> R17
;	recvBits -> Y+14
;	i -> R16
;	buff -> Y+2
	LDD  R30,Y+23
	STD  Y+2,R30
; 0002 0174     buff[1] = BlockAddr;
	LDD  R30,Y+22
	STD  Y+3,R30
; 0002 0175     for (i=0; i<6; i++)
	LDI  R16,LOW(0)
_0x40034:
	CPI  R16,6
	BRSH _0x40035
; 0002 0176     {
; 0002 0177 		buff[i+2] = *(Sectorkey+i);
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,2
	CALL SUBOPT_0xF
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0x10
; 0002 0178 	}
	SUBI R16,-1
	RJMP _0x40034
_0x40035:
; 0002 0179     for (i=0; i<4; i++)
	LDI  R16,LOW(0)
_0x40037:
	CPI  R16,4
	BRSH _0x40038
; 0002 017A     {
; 0002 017B 		buff[i+8] = *(serNum+i);
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,8
	CALL SUBOPT_0xF
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0x10
; 0002 017C 	}
	SUBI R16,-1
	RJMP _0x40037
_0x40038:
; 0002 017D     status = mfrc522_to_card(PCD_AUTHENT, buff, 12, buff, &recvBits);
	LDI  R30,LOW(14)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,20
	RCALL _mfrc522_to_card
	MOV  R17,R30
; 0002 017E     i = mfrc522_read(Status2Reg);
	LDI  R26,LOW(8)
	RCALL _mfrc522_read
	MOV  R16,R30
; 0002 017F 
; 0002 0180     if ((status != CARD_FOUND) || (!(i & 0x08)))
	CPI  R17,1
	BRNE _0x4003A
	SBRC R16,3
	RJMP _0x40039
_0x4003A:
; 0002 0181     {
; 0002 0182 		status = ERROR;
	LDI  R17,LOW(3)
; 0002 0183 	}
; 0002 0184 
; 0002 0185     return status;
_0x40039:
	MOV  R30,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,24
	RET
; 0002 0186 }
;
;/*
; * Function Name : MFRC522_Write
; * Description : Write block data
; * Input parameters : blockAddr - block address ; writeData - to 16-byte data block write
; * Return value: the successful return CARD_FOUND
; */
;uint8_t mfrc522_write_block(uint8_t blockAddr, uint8_t *writeData)
; 0002 018F {
; 0002 0190     uint8_t status;
; 0002 0191     uint32_t recvBits;
; 0002 0192     uint8_t i;
; 0002 0193 	uint8_t buff[18];
; 0002 0194 
; 0002 0195     buff[0] = PICC_WRITE;
;	blockAddr -> Y+26
;	*writeData -> Y+24
;	status -> R17
;	recvBits -> Y+20
;	i -> R16
;	buff -> Y+2
; 0002 0196     buff[1] = blockAddr;
; 0002 0197     mfrc522_calculateCRC(buff, 2, &buff[2]);
; 0002 0198     status = mfrc522_to_card(PCD_TRANSCEIVE, buff, 4, buff, &recvBits);
; 0002 0199 
; 0002 019A     //cek
; 0002 019B     //printf("w1 = %d\t%d\t%.2X\n", status, recvBits, buff[0]);
; 0002 019C 
; 0002 019D     if ((status != CARD_FOUND) || (recvBits != 4) || ((buff[0] & 0x0F) != 0x0A))
; 0002 019E     {
; 0002 019F 		status = ERROR;
; 0002 01A0 	}
; 0002 01A1 
; 0002 01A2     if (status == CARD_FOUND)
; 0002 01A3     {
; 0002 01A4         for (i=0; i<16; i++)		//?FIFO?16Byte??
; 0002 01A5         {
; 0002 01A6         	buff[i] = *(writeData+i);
; 0002 01A7         }
; 0002 01A8         mfrc522_calculateCRC(buff, 16, &buff[16]);
; 0002 01A9         status = mfrc522_to_card(PCD_TRANSCEIVE, buff, 18, buff, &recvBits);
; 0002 01AA 
; 0002 01AB         //cek
; 0002 01AC         //printf("w2 = %d\t%d\t%.2X\n", status, recvBits, buff[0]);
; 0002 01AD 
; 0002 01AE 		if ((status != CARD_FOUND) || (recvBits != 4) || ((buff[0] & 0x0F) != 0x0A))
; 0002 01AF         {
; 0002 01B0 			status = ERROR;
; 0002 01B1 		}
; 0002 01B2     }
; 0002 01B3 
; 0002 01B4     return status;
; 0002 01B5 }
;
;/*
; * Function Name : MFRC522_Read
; * Description : Read block data
; * Input parameters : blockAddr - block address ; recvData - read block data
; * Return value: the successful return MI_OK
; */
;uint8_t mfrc522_read_block(uint8_t blockAddr, uint8_t *recvData)
; 0002 01BE {
_mfrc522_read_block:
; 0002 01BF     uint8_t status;
; 0002 01C0     uint32_t unLen;
; 0002 01C1 
; 0002 01C2     recvData[0] = PICC_READ;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
;	blockAddr -> Y+7
;	*recvData -> Y+5
;	status -> R17
;	unLen -> Y+1
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(48)
	ST   X,R30
; 0002 01C3     recvData[1] = blockAddr;
	LDD  R30,Y+7
	__PUTB1SNS 5,1
; 0002 01C4     mfrc522_calculateCRC(recvData,2, &recvData[2]);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,2
	RCALL _mfrc522_calculateCRC
; 0002 01C5     status = mfrc522_to_card(PCD_TRANSCEIVE, recvData, 4, recvData, &unLen);
	CALL SUBOPT_0x5
	LDI  R30,LOW(4)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0002 01C6 
; 0002 01C7     //cek
; 0002 01C8 //    printf("read block #%d = %.2X %.4X\n", blockAddr, status, unLen);
; 0002 01C9 
; 0002 01CA     if ((status != CARD_FOUND) || (unLen != 0x90))
	BRNE _0x40047
	__GETD2S 1
	__CPD2N 0x90
	BREQ _0x40046
_0x40047:
; 0002 01CB     {
; 0002 01CC         status = ERROR;
	LDI  R17,LOW(3)
; 0002 01CD     }
; 0002 01CE 
; 0002 01CF     return status;
_0x40046:
_0x2060004:
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,8
	RET
; 0002 01D0 }
;
;/*
; * Function Name : MFRC522_SelectTag
; * Description: election card , read the card memory capacity
; * Input parameters : serNum - Incoming card serial number
; * Return value: the successful return of card capacity
; */
;uint8_t mfrc522_select_tag(uint8_t *serNum)
; 0002 01D9 {
_mfrc522_select_tag:
; 0002 01DA     uint8_t i;
; 0002 01DB 	uint8_t status;
; 0002 01DC 	uint8_t size;
; 0002 01DD     uint32_t recvBits;
; 0002 01DE     uint8_t buffer[9];
; 0002 01DF 
; 0002 01E0 	//ClearBitMask(Status2Reg, 0x08);			//MFCrypto1On=0
; 0002 01E1 
; 0002 01E2     buffer[0] = PICC_SElECTTAG;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,13
	CALL __SAVELOCR4
;	*serNum -> Y+17
;	i -> R17
;	status -> R16
;	size -> R19
;	recvBits -> Y+13
;	buffer -> Y+4
	LDI  R30,LOW(147)
	STD  Y+4,R30
; 0002 01E3     buffer[1] = 0x70;
	LDI  R30,LOW(112)
	STD  Y+5,R30
; 0002 01E4     for (i=0; i<5; i++)
	LDI  R17,LOW(0)
_0x4004A:
	CPI  R17,5
	BRSH _0x4004B
; 0002 01E5     {
; 0002 01E6     	buffer[i+2] = *(serNum+i);
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,2
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x10
; 0002 01E7     }
	SUBI R17,-1
	RJMP _0x4004A
_0x4004B:
; 0002 01E8 	mfrc522_calculateCRC(buffer, 7, &buffer[7]);		//??
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,14
	RCALL _mfrc522_calculateCRC
; 0002 01E9     status = mfrc522_to_card(PCD_TRANSCEIVE, buffer, 9, buffer, &recvBits);
	LDI  R30,LOW(12)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,19
	RCALL _mfrc522_to_card
	MOV  R16,R30
; 0002 01EA 
; 0002 01EB     if ((status == CARD_FOUND) && (recvBits == 0x18))
	CPI  R16,1
	BRNE _0x4004D
	__GETD2S 13
	__CPD2N 0x18
	BREQ _0x4004E
_0x4004D:
	RJMP _0x4004C
_0x4004E:
; 0002 01EC     {
; 0002 01ED 		size = buffer[0];
	LDD  R19,Y+4
; 0002 01EE 	}
; 0002 01EF     else
	RJMP _0x4004F
_0x4004C:
; 0002 01F0     {
; 0002 01F1 		size = 0;
	LDI  R19,LOW(0)
; 0002 01F2 	}
_0x4004F:
; 0002 01F3 
; 0002 01F4     return size;
	MOV  R30,R19
	CALL __LOADLOCR4
_0x2060003:
	ADIW R28,19
	RET
; 0002 01F5 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060002:
	ADIW R28,1
	RET
_put_usart_G100:
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060001:
	ADIW R28,3
	RET
__print_G100:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	CALL __SAVELOCR6
	LDI  R17,0
	CALL SUBOPT_0x2
_0x2000016:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ADIW R30,1
	STD  Y+24,R30
	STD  Y+24+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x11
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x11
	RJMP _0x20000E4
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BRNE _0x2000028
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200002C
	LDI  R17,LOW(4)
	RJMP _0x200001B
_0x200002C:
	RJMP _0x200002D
_0x2000028:
	CPI  R30,LOW(0x4)
	BRNE _0x200002F
	CPI  R18,48
	BRLO _0x2000031
	CPI  R18,58
	BRLO _0x2000032
_0x2000031:
	RJMP _0x2000030
_0x2000032:
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200001B
_0x2000030:
_0x200002D:
	CPI  R18,108
	BRNE _0x2000033
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200001B
_0x2000033:
	RJMP _0x2000034
_0x200002F:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x200001B
_0x2000034:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000039
	CALL SUBOPT_0x12
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x13
	RJMP _0x200003A
_0x2000039:
	CPI  R30,LOW(0x73)
	BRNE _0x200003C
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CALL _strlen
	MOV  R17,R30
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x70)
	BRNE _0x200003F
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200003D:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000041
	CP   R20,R17
	BRLO _0x2000042
_0x2000041:
	RJMP _0x2000040
_0x2000042:
	MOV  R17,R20
_0x2000040:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000043
_0x200003F:
	CPI  R30,LOW(0x64)
	BREQ _0x2000046
	CPI  R30,LOW(0x69)
	BRNE _0x2000047
_0x2000046:
	ORI  R16,LOW(4)
	RJMP _0x2000048
_0x2000047:
	CPI  R30,LOW(0x75)
	BRNE _0x2000049
_0x2000048:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x200004A
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x15
	LDI  R17,LOW(10)
	RJMP _0x200004B
_0x200004A:
	__GETD1N 0x2710
	CALL SUBOPT_0x15
	LDI  R17,LOW(5)
	RJMP _0x200004B
_0x2000049:
	CPI  R30,LOW(0x58)
	BRNE _0x200004D
	ORI  R16,LOW(8)
	RJMP _0x200004E
_0x200004D:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x200008C
_0x200004E:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000050
	__GETD1N 0x10000000
	CALL SUBOPT_0x15
	LDI  R17,LOW(8)
	RJMP _0x200004B
_0x2000050:
	__GETD1N 0x1000
	CALL SUBOPT_0x15
	LDI  R17,LOW(4)
_0x200004B:
	CPI  R20,0
	BREQ _0x2000051
	ANDI R16,LOW(127)
	RJMP _0x2000052
_0x2000051:
	LDI  R20,LOW(1)
_0x2000052:
	SBRS R16,1
	RJMP _0x2000053
	CALL SUBOPT_0x12
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x20000E5
_0x2000053:
	SBRS R16,2
	RJMP _0x2000055
	CALL SUBOPT_0x12
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x20000E5
_0x2000055:
	CALL SUBOPT_0x12
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x20000E5:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x2000057
	LDD  R26,Y+15
	TST  R26
	BRPL _0x2000058
	__GETD1S 12
	CALL __ANEGD1
	__PUTD1S 12
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x2000058:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x2000059
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200005A
_0x2000059:
	ANDI R16,LOW(251)
_0x200005A:
_0x2000057:
	MOV  R19,R20
_0x2000043:
	SBRC R16,0
	RJMP _0x200005B
_0x200005C:
	CP   R17,R21
	BRSH _0x200005F
	CP   R19,R21
	BRLO _0x2000060
_0x200005F:
	RJMP _0x200005E
_0x2000060:
	SBRS R16,7
	RJMP _0x2000061
	SBRS R16,2
	RJMP _0x2000062
	ANDI R16,LOW(251)
	LDD  R18,Y+17
	SUBI R17,LOW(1)
	RJMP _0x2000063
_0x2000062:
	LDI  R18,LOW(48)
_0x2000063:
	RJMP _0x2000064
_0x2000061:
	LDI  R18,LOW(32)
_0x2000064:
	CALL SUBOPT_0x11
	SUBI R21,LOW(1)
	RJMP _0x200005C
_0x200005E:
_0x200005B:
_0x2000065:
	CP   R17,R20
	BRSH _0x2000067
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000068
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	CALL SUBOPT_0x13
	CPI  R21,0
	BREQ _0x2000069
	SUBI R21,LOW(1)
_0x2000069:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000068:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x13
	CPI  R21,0
	BREQ _0x200006A
	SUBI R21,LOW(1)
_0x200006A:
	SUBI R20,LOW(1)
	RJMP _0x2000065
_0x2000067:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x200006B
_0x200006C:
	CPI  R19,0
	BREQ _0x200006E
	SBRS R16,3
	RJMP _0x200006F
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000070
_0x200006F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000070:
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
	SUBI R19,LOW(1)
	RJMP _0x200006C
_0x200006E:
	RJMP _0x2000072
_0x200006B:
_0x2000074:
	CALL SUBOPT_0x16
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000076
	SBRS R16,3
	RJMP _0x2000077
	SUBI R18,-LOW(55)
	RJMP _0x2000078
_0x2000077:
	SUBI R18,-LOW(87)
_0x2000078:
	RJMP _0x2000079
_0x2000076:
	SUBI R18,-LOW(48)
_0x2000079:
	SBRC R16,4
	RJMP _0x200007B
	CPI  R18,49
	BRSH _0x200007D
	__GETD2S 8
	__CPD2N 0x1
	BRNE _0x200007C
_0x200007D:
	RJMP _0x200007F
_0x200007C:
	CP   R20,R19
	BRSH _0x20000E6
	CP   R21,R19
	BRLO _0x2000082
	SBRS R16,0
	RJMP _0x2000083
_0x2000082:
	RJMP _0x2000081
_0x2000083:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000084
_0x20000E6:
	LDI  R18,LOW(48)
_0x200007F:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000085
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	CALL SUBOPT_0x13
	CPI  R21,0
	BREQ _0x2000086
	SUBI R21,LOW(1)
_0x2000086:
_0x2000085:
_0x2000084:
_0x200007B:
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2000087
	SUBI R21,LOW(1)
_0x2000087:
_0x2000081:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x16
	CALL __MODD21U
	__PUTD1S 12
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x15
	__GETD1S 8
	CALL __CPD10
	BREQ _0x2000075
	RJMP _0x2000074
_0x2000075:
_0x2000072:
	SBRS R16,0
	RJMP _0x2000088
_0x2000089:
	CPI  R21,0
	BREQ _0x200008B
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x13
	RJMP _0x2000089
_0x200008B:
_0x2000088:
_0x200008C:
_0x200003A:
_0x20000E4:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,26
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG
_memcpy:
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
	ADIW R28,6
	RET
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_keyA_default:
	.BYTE 0x6

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _mfrc522_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	MOVW R26,R28
	ADIW R26,7
	CALL _mfrc522_to_card
	MOV  R17,R30
	CPI  R17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	MOV  R30,R21
	ORI  R30,0x80
	MOV  R26,R30
	JMP  _mfrc522_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	__SUBD1N -1
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	CALL __CWD1
	__GETD2N 0x8
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+2
	CALL _mfrc522_read
	MOV  R17,R30
	LDD  R30,Y+2
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	ST   -Y,R18
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x12:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	__GETD1S 8
	__GETD2S 12
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xBB8
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
