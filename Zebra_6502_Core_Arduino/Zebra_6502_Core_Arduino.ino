#define _SS_MAX_RX_BUFF  710
#include <EEPROM.h>

#include <SoftwareSerial.h>

SoftwareSerial ioSerial(6,7);// RX, TX
SoftwareSerial aySerial(2,5);// RX, TX

#include <PS2Keyboard.h>
/* Keyboard constants  Change to suit your Arduino
   define pins used for data and clock from keyboard */
#define DATAPIN 4
#define IRQPIN  3



uint16_t c;


PS2Keyboard keyboard;

void mem_init()
{
    //DATA I/O
  DDRC=0; //pins A0..A* to INPUTS
  DDRB &= ~(1<<0);
  DDRB &= ~(1<<1); //pins 8 and 9 as inputs too

  //Initialize SPI
  DDRB |= _BV(PINB2); //SS out
  DDRB |= _BV(PINB3);  //mosi out
  DDRB |= _BV(PINB5);  //clk out
  DDRB &= ~(_BV(PINB4)); //miso in
  PORTB |= (1<<2);
  
  SPCR = (1<<SPE)|(1<<MSTR); //spirupt disable, spi endble, msb1 clklow idle, sample on edge, clk/4 rate
  SPSR |= 0x01;  // set SPI2x

}

//shift data out of spi
inline void shift_spi(volatile uint16_t data)
{
  PORTB &= ~(1<<2); //Latch low
  SPDR = data>>8;                    // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  SPDR = data&0xFF;                    // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
   PORTB |= (1<<2); //Latch high
  return ; 
  
}

//Read byte from memory
uint8_t read_byte(unsigned int addr)
{
  //address (with WE high) in
 // bitSet(addr,15);
  shift_spi(addr);
  
  //read byte
  byte a=PINC;
  bitWrite(a,6,bitRead(PINB,0));
  bitWrite(a,7,bitRead(PINB,1));
  return a;
}

//Write data into memory
//WE is Q7 of second register.
void write_byte(unsigned int addr, uint8_t data)
{
  bitSet(addr,15); //address (with WE high) in
   shift_spi(addr);
   
  //bang /WE - a bit faster version
  SPCR=0; //spi temporary off
  DDRB|=(1<<4); //B4 as o/p
  PORTB &= ~(1<<4); // low
  
  //pins to outputs with data
  DDRC=255;
  DDRB|=(1<<0);
  DDRB|=(1<<1);


  PORTC=data; //portc is A-pins. In Uno we don't have much choice.
  data=data>>6;
  bitSet(data,2); //Latch high! Other PORTB pins are nevertheless driven by SPI cntrlr.
  PORTB=data;

 /* 
  //Bang the WE - address with WE low in - slow version
  bitClear(addr,15);
  shift_spi(addr);
  //address with WE  high in
  bitSet(addr,15);
  shift_spi(addr);
  */

  // /WE high again
  PORTB |= (1<<4); // high
  SPCR = (1<<SPE)|(1<<MSTR); //spi on
  //According to spec, /WE has to be internally pulled up. Thus, we can just turn
  //pin 12 to input, and it'll maintain high state.
  
  //data to inputs. They should ALWAYS be inputs 
  //and WE should be high if not in one writing moment.
  DDRC=0; 
  DDRB &= ~(1<<0);
  DDRB &= ~(1<<1);
}


/**
 *
 * MOUSE2Go - an Arduino based 6502 computer
 *
 * Author: Mario Keller
 *
 *
 *
 */

#define UNDOCUMENTED

// set this to a proper value for your Arduino
//#define RAM_SIZE 1536 // Uno, mini or any other 328P
#define RAM_SIZE 6144 //Mega 2560
//#define RAM_SIZE 32768 //Due


#define NMI_pin 5
//#define IRQ_pin 6
//#define RESET_pin 7
#define INSTRUCTIONS_PER_LOOP 100

//#define USE_TIMING 1
//#define SHOW_SPEED 1
//uint8_t diskRAM[720]={};
uint8_t curkey = 0;
unsigned long starttime, endtime, counttime;
uint8_t KBready = 0x00;
uint8_t DSPready = 0x80;

uint8_t DL = 0x00;
uint8_t DH = 0x00;
uint8_t DS = 0x00;
int loadSum = 0;
int booster = 10;



extern "C" {
  uint16_t getpc();
  uint8_t getop();
  void exec6502(int32_t tickcount);
  void reset6502();
  void nmi6502();
  void irq6502();

  void serout(uint8_t val) {
    if (val == 10) {
      Serial.println();
      }
    else {
      
      Serial.write(val);
      }
  }


  uint8_t getkey() {
    
    return(curkey);
  }

  void clearkey() {
    curkey = 0;
  }

  uint16_t getRAM(unsigned int addr) {
    
    return(read_byte(addr));
  }

  void setRAM(unsigned int addr, uint8_t data) {
    if ((addr >= 0x7110) && (addr < 0x7130)){  // SET Color
        Serial.write(0xF1);
        Serial.write(addr-0x7110);
        Serial.write(data);
        Serial.write(0xF2);
      }else if ((addr >= 0x7130) && (addr < 0x7310)){  // BLK
        delay(5);
        Serial.write(0xF3);
        if((addr-0x7130) <= 0xff){
            if((addr-0x7130) <= 0x80){
              Serial.write(addr-0x7130);
              Serial.write(0x00);
              Serial.write(0x00);
              
              }else{
                Serial.write(0x80);
                Serial.write(addr-0x7130-0x80);
                Serial.write(0x00);  
                }
            
            
          }else{
          
            Serial.write(0x80);
            Serial.write(0x7F);
            Serial.write((addr-0x7130-0xFF));
          
          }

          Serial.write(data);
            Serial.write(0xF4);
        
      }else if((addr >= 0x7310) && (addr < 0x7400)){
        Serial.write(0xF5);
        Serial.write(addr-0x7310);
        Serial.write(0x00);
        Serial.write(0x00);
        Serial.write(data);
        Serial.write(0xF6);
        
        }else if(addr == 0x710D){
              DL = data;
          }else if(addr == 0x710E){
              DH = data;
            }else if(addr == 0x710F){
              DS = data;
            }else if ((addr >= 0x70EC) && (addr < 0x7100)){  // SET Color
        Serial.write(0xF7);
        Serial.write(addr-0x70EC);
        Serial.write(data);
        Serial.write(0xF9);
      }else if ((addr >= 0x70C0) && (addr < 0x70EC)){  // SET ODD Color
        Serial.write(0xF8);
        Serial.write(addr-0x70C0);
        Serial.write(data);
        Serial.write(0xF9);
      }else if (addr == 0x70BF){  // SET FSC Color
        Serial.write(0xFA);
        Serial.write(data);
        Serial.write(0xFB);
      }else if ((addr >= 0x70BB) && (addr < 0x70BF)){  // SET Sig
        Serial.write(0xFC);
        Serial.write(addr-0x70BB);
        Serial.write(data);
        Serial.write(0xFD);
      }


    return(write_byte(addr,data));
  }

  uint16_t getEEPROM(unsigned int addr) {
    
    return(EEPROM.read(addr));
  }

  void setEEPROM(unsigned int addr, uint8_t data) {
    
    return(EEPROM.write(addr,data));
  }


 

  uint8_t getRandom() {
    
    return (random(0,255));
  }

   void insVRAM(uint8_t ins) {
    Serial.write(ins);
    
  }

  void setBooster(uint8_t ins) {
    if (ins == 0) booster = 100;
    else if (ins == 1) booster = 7000;
    
  }

 

  void insAY(uint8_t ins) {

    aySerial.listen();
    aySerial.write(0xFF);
    aySerial.write(ins);
    
  }

  void setAYReg(unsigned int addr, uint8_t data) {
    aySerial.listen();
    aySerial.write(0xFF);
    aySerial.write(addr - 0xA000);
    aySerial.write(data);
   
    }

  void setFullLineColor(uint8_t data) {
        for (int i = 0; i < 20; i++){
        Serial.write(0xF1);
        Serial.write(i);
        Serial.write(data);
        Serial.write(0xF2);
        }
  }

  void setBlkModeAxis(uint8_t ins) {

  
      Serial.write(0x7130 + read_byte(0x7100) + read_byte(0x7101)*24);
    
    
  }

  void setTxtModeAxis(uint8_t ins) {

    int a=0x7310 + read_byte(0x7100);
    int a1=a+(read_byte(0x7101))*20;
    int b=read_byte(0x7102);
    
     //setRAM((0x7310 + read_byte(0x7100) + (read_byte(0x7101))*20),read_byte(0x7102));
      setRAM(a1,b);
    
    
  }

  void falshVramBLK(int a){
    if (a == 1){
    for (int i=0x7130;i < 0x7310; i++) setRAM(i,0);
    }

    if (a == 0){
    for (int i=0x7310;i < 0x7400; i++) setRAM(i,0);
    }
  }

  void insIO(uint8_t ins) {
    if(ins == 0x00){  //SAVE
        ioSerial.listen();
        ioSerial.write(0x46);
        ioSerial.write(0x46);
        ioSerial.write(0x46);
        ioSerial.write(DS);
        for(int i= DH*256 + DL;i <=DH*256 + DL+(DS+1)*48;i++){
            ioSerial.write(read_byte(i));
          }
        ioSerial.write(0x48);
        ioSerial.write(0x48);
        ioSerial.write(0x48);
      }

    if(ins == 0x01){  //LOAD
        loadSum = 0;
        ioSerial.listen();
        ioSerial.write(0x39);
        ioSerial.write(0x39);
        ioSerial.write(0x39);
        ioSerial.write(DS);
        
      }
    
  }



}

void setup () {
  randomSeed(analogRead(5));
  keyboard.begin( DATAPIN, IRQPIN );
    mem_init();
  Serial.begin (9600);
 
  ioSerial.begin(9600);
  aySerial.begin(57600);
//mySerial.listen();

//pinMode(5, OUTPUT);
//digitalWrite(5,HIGH);
  

  //Serial.println();

  //set the externes pins for NMI, IRQ and RESET
//  pinMode(NMI_pin, INPUT_PULLUP);
//  pinMode(IRQ_pin, INPUT_PULLUP);
//  pinMode(RESET_pin, INPUT_PULLUP);
  counttime = 0;
  reset6502();
}

void loop () {

  //internal pullup resistor is used for the input pins
  //making them LOW active like the original 6502 pins
  //handle NMI
//  if(!digitalRead(NMI_pin) ) {
//    while(!digitalRead(NMI_pin)) { delay(10); }
//    nmi6502();
//  }
//  //handle IRQ
//  if(!digitalRead(IRQ_pin)) {
//    while(!digitalRead(IRQ_pin)) { delay(10); }
//    irq6502();
//  }


  //handle RESET
//  if(!digitalRead(RESET_pin)) {
//    while(!digitalRead(RESET_pin)) { delay(10); }
//    reset6502();
//  }

   //if timing is enabled, this value is in 6502 clock ticks. otherwise, simply instruction count.


  exec6502 (booster);
  //Serial.print(keyboard.available( ));
  
  while (ioSerial.available()) {  // zDisk IO LOAD
      
          write_byte(DH*256 + DL+ loadSum,ioSerial.read());
          loadSum++;
          
        }
   while (Serial.available()){
       curkey = Serial.read();
       exec6502(100); //7000
       
    }


  if( keyboard.available( ) )
  {
   
  // read the next key
 
  c = keyboard.read();
  //mySerial.print(diskRAM[2],HEX);
  
  curkey = c;
  if (c == 0x09){
    
    reset6502();
    curkey = 0;
  }else if(c == 0x0){
    
    }
 
  }


 
}
