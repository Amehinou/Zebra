 /*****************************************************************************
    System Name : TVoutColor_NTSC
    File Name   : TVoutColor_xxxxxxxx.ino
    Content     : 
    Version     : 0.0
    CPU board   : Arduino UNO/Duemilanove
    Compiler    : Arduino 1.0.4
    History     : 2013/10/04
*****************************************************************************/
/*----------------------------------------------------------------------------
;  Copyleft @Nabe_RMC
;---------------------------------------------------------------------------*/

/*==========================================================================*/
/*  Includes                                                                */
/*==========================================================================*/
#include "defSYS.h"
#include "defCRT.h"
#include "defINT.h"
#include "defCSL.h"
#include <avr/pgmspace.h>

/*==========================================================================*/
/*                                                                          */
/*==========================================================================*/

/*                               01234567890123456789                       */


/*==========================================================================*/
/*  Program                                                                 */
/*==========================================================================*/
CSYS objSYS;
CCRT objCRT;
CCSL objCSL;
CINT IobjINT;

void Ini_PT_TXT(void);
void Ini_PT_BLK(void);
void Ini_PT_FSC(void);
void Clear_BLK(void);
void Set_TestColor_A(void);
void Set_Color( UB );
void Put_Block(int);
void Change_Color(void);

void Clear_Block(void);

void Set_TestColor_TXT( UB );
void Set_TestColor_TXT_ODD( UB );
uint8_t curkey = 0;
int setVramMode = 0;
int setColorMode = 0;
int setColorAdvanceMode = 0;
int setColorAdvanceFullscreenMode = 0;
int setColorAdvanceSigMode = 0;
bool isFirstValue = true;
int colorLineNumber = 0;
bool vramL = false;
bool vramL2 = false;
bool vramH = false;
bool vramValue = false;
bool isTXTmode = false;
bool isODD = false;
int setPixel = 0;
int FSC_COLOR = 0;
int colorBook[3];



void setup()
{
    cli();
    objSYS.Ini();                   /* re-initialize for Arduini IDE init() */
    //Ini_PT_BLK();
    randomSeed(analogRead(0));
    Serial.begin(9600);
    objSYS.IniUART();               /* for Crystal 16MHz ->14.31818NHz      */
    sei();                          /* interrupt enable                     */
    Ini_PT_TXT();
    Set_TestColor_A();
    objCSL.clear_screen(); 
    objCSL.set_cursor(0,0);
    //Serial.print("ok");
}

void loop() 
{
    

    if (Serial.available()) {
    curkey = Serial.read();
    Serial.write(curkey);
    if (curkey == 0xF1){
      setColorMode = 1;
      //Serial.write(curkey);
    }
    
    if (curkey == 0xF2){
      setColorMode = 0;
      isFirstValue = true;
      //Serial.write(curkey);
    }
    
    
    if (curkey == 0xF7){
      isODD = false;
      setColorAdvanceMode = 1;
      //Serial.write(curkey);
    }
    
    if (curkey == 0xF8){
      isODD = true;
      setColorAdvanceMode = 1;
      //Serial.write(curkey);
    }
    
    if (curkey == 0xF9){
      setColorAdvanceMode = 0;
      isFirstValue = true;
      //Serial.write(curkey);
    }
    //=================================================
    if (curkey == 0xFA){
      setColorAdvanceFullscreenMode = 1;
      //Serial.write(curkey);
    }
    
    if (curkey == 0xFB){
      setColorAdvanceFullscreenMode = 0;
      isFirstValue = true;
      //Serial.write(curkey);
    }
    
    //==========================================================
    if (curkey == 0xFC){
      setColorAdvanceSigMode = 1;
      //Serial.write(curkey);
    }
    
    if (curkey == 0xFD){
      setColorAdvanceSigMode = 0;
      isFirstValue = true;
      //Serial.write(curkey);
    }
   //========================================================================= TXT Vram
     if (curkey == 0xF5){
      setVramMode = 1;
      setPixel = 0;
      vramL = true;
      vramH = false;
      vramValue = false;
      isTXTmode = true;
    }
    
    if (curkey == 0xF6){
      setVramMode = 0;
      isTXTmode = false;
    }
    
    // //========================================================================= BLK Vram
     if (curkey == 0xF3){
      setVramMode = 1;
      setPixel = 0;
      vramL = true;
      vramL2 = false;
      vramH = false;
      vramValue = false;
    }
    
    if (curkey == 0xF4){
      setVramMode = 0;
    }
    //==========================================================================================
    
    
    
    
    
     if((curkey >=0x00) && (curkey <= 0xF0) &&  (setVramMode == 1) && (setColorMode == 0)){    // VRAM MODE
        
      
       if (vramL) { 
          setPixel = curkey;              //0x
          vramL = false;
          vramL2 = true;
          //Serial.write(curkey);
         
       }else if(vramL2){
         if(curkey > 0){
         setPixel = setPixel + curkey; 
         }                                      //x0
         vramL2 = false;
         vramH = true;
         //Serial.write(curkey);
       }else if(vramH){
          setPixel = setPixel + curkey;
          vramH = false;
          vramValue = true;
          //Serial.write(curkey);
         
       }else if(vramValue && !isTXTmode){
         
        vram_data[setPixel] = curkey;
        UB_CMD_SetVram = BLOCK_MODE;
         objCSL.SetVram();
        vramValue = false;
        //Serial.println(setPixel);
       }else if(vramValue && isTXTmode){
           vram_data[setPixel] = curkey;
           vramValue = false;
           //Serial.write(curkey);
       }
      
    }
    
    if((curkey >=0) && (curkey < 0xF0) && (setVramMode == 0) && (setColorMode == 1)){   // SET COLOR
      
       if (isFirstValue) {
         colorLineNumber = curkey;
         isFirstValue = false;
         //Serial.write(curkey);
       }else{
         UB_ColorN[colorLineNumber] = curkey; 
         UB_ColorN_ODD[colorLineNumber] = curkey;
         isFirstValue = true;
         //Serial.write(curkey);
       } 
      
    }
    
    if((curkey >=0) && (curkey < 0xF0) && (setVramMode == 0) && (setColorAdvanceMode == 1)){   // SET COLOR Advance
       
       if (isFirstValue) {
         colorLineNumber = curkey;
         isFirstValue = false;
         //Serial.write(curkey);
       }else{
         if (isODD){
           UB_ColorN_ODD[colorLineNumber] = curkey;
         }else{
           UB_ColorN[colorLineNumber] = curkey; 
         }
         isFirstValue = true;
         //Serial.write(curkey);
       } 
      
    }
    
    if((curkey >=0) && (curkey < 0xF0) && (setVramMode == 0) && (setColorAdvanceFullscreenMode == 1)){   // SET FSC COLOR Advance
       
       FSC_COLOR =  curkey;
       Set_FSC_Color( FSC_COLOR );
      
    }
    
    if((curkey >=0) && (curkey < 0xF0) && (setVramMode == 0) && (setColorAdvanceFullscreenMode == 1)){   // SET Sig Advance
       
       if (isFirstValue) {
         colorLineNumber = curkey;
         isFirstValue = false;
         //Serial.write(curkey);
       }else{
         colorBook[colorLineNumber] = curkey;
         isFirstValue = true;
         //Serial.write(curkey);
       } 
       UB_Sig1 = colorBook[0];
       UB_Sig2 = colorBook[1];
       UB_Sig3 = colorBook[2];
       UB_Sig4 = colorBook[3];
       
      
    }
    
    
    if(curkey == 255 || ((curkey >=10) && (curkey <= 131) &&  (setVramMode == 0) && (setColorMode == 0) && (setColorAdvanceMode == 0) && (setColorAdvanceFullscreenMode == 0) && (setColorAdvanceSigMode == 0)) ){
      switch(curkey){
      case 0x80:Ini_PT_TXT();break;
      case 0x81:Ini_PT_BLK( );break;
      case 0x82:Ini_PT_FSC();break;
      case 0xFF:objCSL.clear_screen();objCSL.set_cursor(0,0);break;
      case 0x83:break;
      default:objCSL.put_char(curkey);
      }
    }
    
    
    
    
   
  }
    

}




void Ini_PT_TXT( void )
{
    cli();
    UB_ModePTN = TEXT_MODE;
    UB_ModePLS = FRM_OFF;
    IobjINT.ClearLineData();
    UH_AddrData_n = (UH)(&vram_line[0]);
    Set_TestColor_A();
    objCSL.clear_screen();
    sei();
}

void Ini_PT_FSC( void )
{
    cli();
    UB_ModePTN = FSC_MODE;
    UB_ModePLS = FRM_OFF;
    Set_FSC_Color( FSC_COLOR );
    sei();
}

void Set_FSC_Color( UB color )
{
    switch( color ){
        case 0:
            UB_Sig1 = 25;
            UB_Sig2 = 25;
            UB_Sig3 = 25;
            UB_Sig4 = 25;
            break;
        
        case 1:
            UB_Sig1 = 9;
            UB_Sig2 = 13;
            UB_Sig3 = 27;
            UB_Sig4 = 23;
            break;
        
        case 2:
            UB_Sig1 = 8;
            UB_Sig2 = 18;
            UB_Sig3 = 12;
            UB_Sig4 = 2;
            break;
        
        case 3:
            UB_Sig1 = 24;
            UB_Sig2 = 20;
            UB_Sig3 = 6;
            UB_Sig4 = 10;
            break;
        
        case 4:
            UB_Sig1 = 9;
            UB_Sig2 = 23;
            UB_Sig3 = 31;
            UB_Sig4 = 17;
            break;
        
        case 5:
            UB_Sig1 = 25;
            UB_Sig2 = 15;
            UB_Sig3 = 21;
            UB_Sig4 = 31;
            break;
        
        case 6:
            UB_Sig1 = 24;
            UB_Sig2 = 10;
            UB_Sig3 = 2;
            UB_Sig4 = 16;
            break;
        
    case 7:
            UB_Sig1 = 7;
            UB_Sig2 = 7;
            UB_Sig3 = 7;
            UB_Sig4 = 7;
            break;

    deafult:
            UB_Sig1 = 25;
            UB_Sig2 = 25;
            UB_Sig3 = 25;
            UB_Sig4 = 25;
        
    }
}



/*  ----------------------------------------------------
    -   Initialize Block Display Mode                  -
    -----------------------------------------------------   */
void Ini_PT_BLK( void )
{
    cli();
    UB_ModePTN_BF = 4;
    UB_ModePTN = 4;
    UB_CMD_SetVram = BLOCK_MODE;
    UB_ModePLS = FRM_OFF;
    IobjINT.ClearLineData();
    UH_AddrData_n = (UH)(&vram_line[0]);
    UH_AddrData_n_ODD = (UH)(&vram_line[COL_MAX_BLK*ROW_MAX_BLK]);
    Set_TestColor_A();
    Clear_BLK();
    sei();
}


/*----------------------------------------------------------------------------
    Demo for Text Display
    
        How to use objCSL.put_char , objSYS.delay132
----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------
    Set Color for Test
        
        Changeable for every even number and odd number
        Changeable for every line
----------------------------------------------------------------------------*/
void Set_TestColor_A(void)
{
    UB_ColorN[0] = COL_RED;     UB_ColorN_ODD[0] = COL_RED;
    UB_ColorN[1] = COL_WHI;     UB_ColorN_ODD[1] = COL_WHI;
    UB_ColorN[2] = COL_BLU;     UB_ColorN_ODD[2] = COL_MAG;
    UB_ColorN[3] = COL_YEL;     UB_ColorN_ODD[3] = COL_YEL;
    UB_ColorN[4] = COL_CYN;     UB_ColorN_ODD[4] = COL_CYN;
    UB_ColorN[5] = COL_YEL;     UB_ColorN_ODD[5] = COL_YEL;
    UB_ColorN[6] = COL_RED;     UB_ColorN_ODD[6] = COL_RED;
    UB_ColorN[7] = COL_WHI;     UB_ColorN_ODD[7] = COL_WHI;
    UB_ColorN[8] = COL_GRN;     UB_ColorN_ODD[8] = COL_GRN;
    UB_ColorN[9] = COL_YEL;     UB_ColorN_ODD[9] = COL_YEL;
    UB_ColorN[10] = COL_MAG;    UB_ColorN_ODD[10] = COL_MAG;
    UB_ColorN[11] = COL_CYN;    UB_ColorN_ODD[11] = COL_CYN;
    UB_ColorN[12] = COL_GRN;     UB_ColorN_ODD[12] = COL_GRN;
    UB_ColorN[13] = COL_BLU;     UB_ColorN_ODD[13] = COL_BLU;
    UB_ColorN[14] = COL_MAG;     UB_ColorN_ODD[14] = COL_MAG;
    UB_ColorN[15] = COL_CYN;     UB_ColorN_ODD[15] = COL_CYN;
    UB_ColorN[16] = COL_YEL;     UB_ColorN_ODD[16] = COL_YEL;
    UB_ColorN[17] = COL_RED;     UB_ColorN_ODD[17] = COL_RED;
    UB_ColorN[18] = COL_WHI;     UB_ColorN_ODD[18] = COL_WHI;
    UB_ColorN[19] = COL_GRN;     UB_ColorN_ODD[19] = COL_GRN;
    
   
}



/*  ----------------------------------------------------
    -   Set Color Line 1 - 12 for Text Display          -
    -----------------------------------------------------   */
void Set_TestColor_TXT( UB color )
{
    UB i;
    
    for( i = 3; i < 12; i++ ){
        UB_ColorN[i] = color;
        color++;
        if( color > 6 ){
            color = 0;
        }
    }
}

void Set_TestColor_TXT_ODD( UB color )
{
    UB i;
    
    for( i = 3; i < 12; i++ ){
        UB_ColorN_ODD[i] = color;
        color++;
        if( color > 6 ){
            color = 0;
        }
    }
}
    

/*  ----------------------------------------------------
    -   Block Clear                                    -
    -----------------------------------------------------   */
void Clear_BLK( void )
{
    UH i;
    
    for( i=0; i < TXT_SIZE; i++ ){
        vram_data[i] = 0x00;        /* blank data at MoePTN = 4 or 5        */
    }
    for( i=0; i < LINE_SIZE; i++ ){
        vram_line[i] = 0x00;
    }
}


/*  ----------------------------------------------------
    -   Set Color of Screen                            -
    -----------------------------------------------------   */
void Set_Color( UB color )
{
    UB i;
    
    for( i = 0; i < ROW_MAX_BLK ; i++ ){
        UB_ColorN[i] = color;
        UB_ColorN_ODD[i] = color;
    }
}


/*  ----------------------------------------------------
    -   Put Block                                      -
    -----------------------------------------------------   */
void Put_Block( int i )
{
    
        vram_data[i] = 0x1F;
        UB_CMD_SetVram = BLOCK_MODE;
        objCSL.SetVram();
        objSYS.delay132( 1 ); 
    
}


/*  ----------------------------------------------------
    -   Change Color of Block                           -
    -----------------------------------------------------   */
void Change_Color( void )
{
    UH i,k;
    UB c_data1,c_data2;
    
    for( i = 0; i < 50; i++ ){
        c_data1 = UB_ColorN[0];
        c_data2 = UB_ColorN_ODD[0];
        for( k = 0; k < (ROW_MAX_BLK-1); k++ ){
            UB_ColorN[k] = UB_ColorN[k+1];
            UB_ColorN_ODD[k] = UB_ColorN_ODD[k+1];
        }
        UB_ColorN[ROW_MAX_BLK-1] = c_data1;
        UB_ColorN_ODD[ROW_MAX_BLK-1] = c_data2;
        objSYS.delay132( 1 );
    }
}


/*  ----------------------------------------------------
    -   Change Color at Display Menu                    -
    -----------------------------------------------------   */

/*  ----------------------------------------------------
    -   Clear Block Random                             -
    -----------------------------------------------------   */
void Clear_Block( void )
{
    UH i;
    
    for( i = 0; i < 500; i++ ){
        vram_data[(unsigned short)random( 0, FL_COL_MAX_BLK * ROW_MAX_BLK )] = 0x00;
        UB_CMD_SetVram = BLOCK_MODE;
        objCSL.SetVram();
    }
    Clear_BLK();                        /* Clear All Block                  */
}


/*  ----------------------------------------------------
    -   Display Invader Type A                          -
    -----------------------------------------------------   */

