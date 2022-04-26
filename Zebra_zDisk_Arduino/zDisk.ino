/**
 * ----------------------------------------------------------------------------
 * This is a MFRC522 library example; see https://github.com/miguelbalboa/rfid
 * for further details and other examples.
 *
 * NOTE: The library file MFRC522.h has a lot of useful info. Please read it.
 *
 * Released into the public domain.
 * ----------------------------------------------------------------------------
 * This sample shows how to read and write data blocks on a MIFARE Classic PICC
 * (= card/tag).
 *
 * BEWARE: Data will be written to the PICC, in sector #1 (blocks #4 to #7).
 *
 *
 * Typical pin layout used:
 * -----------------------------------------------------------------------------------------
 *             MFRC522      Arduino       Arduino   Arduino    Arduino          Arduino
 *             Reader/PCD   Uno/101       Mega      Nano v3    Leonardo/Micro   Pro Micro
 * Signal      Pin          Pin           Pin       Pin        Pin              Pin
 * -----------------------------------------------------------------------------------------
 * RST/Reset   RST          9             5         D9         RESET/ICSP-5     RST
 * SPI SS      SDA(SS)      10            53        D10        10               10
 * SPI MOSI    MOSI         11 / ICSP-4   51        D11        ICSP-4           16
 * SPI MISO    MISO         12 / ICSP-1   50        D12        ICSP-1           14
 * SPI SCK     SCK          13 / ICSP-3   52        D13        ICSP-3           15
 *
 */


 //3 x 256 byte zDisk
 

#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN         9           // Configurable, see typical pin layout above
#define SS_PIN          10          // Configurable, see typical pin layout above

MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.

MFRC522::MIFARE_Key key;

int insWord = 0;
int insEnd = 0;
int insRead = 0;
bool setBlock = false;
int block = 0;
int zRAM[730] = {};
int c;
int dataNumber = 0;
bool isData = false;
/**
 * Initialize.
 */
void setup() {
    Serial.begin(9600); // Initialize serial communications with the PC
    while (!Serial);    // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4)
    Serial.write(0xFF);
}

/**
 * Main loop.
 */
void loop() {


    if (Serial.available()) {
  
    c = Serial.read();

  //================================================================
    if ((c == 0x39) && (insRead == 0)){
        insRead = 1;
      }else if ((c == 0x39) && (insRead == 1)){
        insRead = 2;
        }else if ((c == 0x39) && (insRead == 2)){
         
          insRead = 3;
          //
          }else if ((c <= 0x15) && (insRead == 3)){
          readRAM(c);
          insRead = 0;
          //
          }else if((c != 0x39) && (insRead > 0)){
                    insRead = 0;
                  }



 //================================================================
    if ((c == 0x48) && isData && (insEnd == 0)) {
        insEnd = 1;
      }else if ((c == 0x48) && isData && (insEnd == 1)){
          insEnd = 2;
        }else if ((c == 0x48) && isData && (insEnd == 2)){
           
            
            writeRAM();
            //block = 0;
            insEnd = 0;
            insWord = 0;
            
            dataNumber = 0;
            isData = false;
            
        }else if((c !=  0x48) && (insEnd > 0) && (insEnd < 2)){
            insEnd = 0;
          }

    //================================================================
    if ((c == 0x46) && (insWord == 0)){
        insWord = 1;
      }else if ((c == 0x46) && (insWord == 1)){
        insWord = 2;
        }else if ((c == 0x46) && (insWord == 2)){
          insWord = 3;
          isData = true;
          }else if((c !=  0x46)  && !isData){
                insWord = 0;
              }
   
   
//================================================================
    if(isData){
        //Serial.write(c);
         zRAM[dataNumber] = c;
         dataNumber++;
      }  
   
   }
  
    
}

int writeRAM(){
     //Serial.write(0x55);
    //Serial.println(dataNumber);
    zRAM[0] = dataNumber;
//    for (int i=2; i < (dataNumber-1);i ++){
//        Serial.write(zRAM[i]);
//    }


    SPI.begin();        // Init SPI bus
    mfrc522.PCD_Init(); // Init MFRC522 card

    // Prepare the key (used both as key A and as key B)
    // using FFFFFFFFFFFFh which is the default at chip delivery from the factory
    for (byte i = 0; i < 6; i++) {
        key.keyByte[i] = 0xFF;
    }

     if ( ! mfrc522.PICC_IsNewCardPresent())
        return;

    // Select one of the cards
    if ( ! mfrc522.PICC_ReadCardSerial())
        return;

    // In this sample we use the second sector,
    
    byte blockAddr      = 4;
    byte dataBlock[16];   
    byte trailerBlock   = 7;
    MFRC522::StatusCode status;
    byte buffer[18];
    byte size = sizeof(buffer);


    for (int i=1; i <= zRAM[1]+1;i++){
        status = (MFRC522::StatusCode) mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_B, 4*i+3, &key, &(mfrc522.uid));
        if (status != MFRC522::STATUS_OK) {
            Serial.print(F("PCD_Authenticate() failed: "));
            Serial.println(mfrc522.GetStatusCodeName(status));
            return;
        }

        for(int j=0;j <3;j++){
            blockAddr = 4*i+j;
            for(int k=0;k < 16;k++){
                  dataBlock[k] = zRAM[k+16*j+(i-1)*16*3+2];
                  //Serial.write(zRAM[k+16*j+(i-1)*16*3]);
              }
             
            status = (MFRC522::StatusCode) mfrc522.MIFARE_Write(blockAddr, dataBlock, 16);
            if (status != MFRC522::STATUS_OK) {
                Serial.print(F("MIFARE_Write() failed: "));
                Serial.println(mfrc522.GetStatusCodeName(status));
            }
            
           //dump_byte_array(buffer, 16); 
            
          }
      }


    // Halt PICC
    mfrc522.PICC_HaltA();
    // Stop encryption on PCD
    mfrc522.PCD_StopCrypto1();
   
    
  }


int readRAM(int r){

   readRF(r);
  
  
//    for (int i=2; i < (zRAM[0]-1);i ++){
//        Serial.write(zRAM[i]);
//    }
  
  }

/**
 * Helper routine to dump a byte array as hex values to Serial.
 */
void dump_byte_array(byte *buffer, byte bufferSize) {
    for (byte i = 0; i < bufferSize; i++) {
        //Serial.print(buffer[i] < 0x10 ? " 0" : " ");
        Serial.write(buffer[i]);
    }
}

void readRF(int r){
 
 
    SPI.begin();        // Init SPI bus
    mfrc522.PCD_Init(); // Init MFRC522 card

    // Prepare the key (used both as key A and as key B)
    // using FFFFFFFFFFFFh which is the default at chip delivery from the factory
    for (byte i = 0; i < 6; i++) {
        key.keyByte[i] = 0xFF;
    }

     if ( ! mfrc522.PICC_IsNewCardPresent())
        return;

    // Select one of the cards
    if ( ! mfrc522.PICC_ReadCardSerial())
        return;

    // In this sample we use the second sector,
    // that is: sector #1, covering block #4 up to and including block #7
    byte sector         = 1;
    byte blockAddr      = 4;
   
    byte trailerBlock   = 7;
    MFRC522::StatusCode status;
    byte buffer[18];
    byte size = sizeof(buffer);

    for (int i=1; i <=r+1;i++){
        status = (MFRC522::StatusCode) mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, 4*i+3, &key, &(mfrc522.uid));
        if (status != MFRC522::STATUS_OK) {
            Serial.print(F("PCD_Authenticate() failed: "));
            Serial.println(mfrc522.GetStatusCodeName(status));
            return;
        }

        for(int j=0;j <3;j++){
            blockAddr = 4*i+j;
            status = (MFRC522::StatusCode) mfrc522.MIFARE_Read(blockAddr, buffer, &size);
            if (status != MFRC522::STATUS_OK) {
                Serial.print(F("MIFARE_Read() failed: "));
                Serial.println(mfrc522.GetStatusCodeName(status));
            }
            
            dump_byte_array(buffer, 16); 
            
          }
      }
  
    

 

    // Halt PICC
    mfrc522.PICC_HaltA();
    // Stop encryption on PCD
    mfrc522.PCD_StopCrypto1();
   
  }
