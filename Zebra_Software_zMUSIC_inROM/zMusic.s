;=====================zMUSIC=====================

.org $BD01

TUNE_PAD: .byte 0,1,2,2,3,4,5

                         ; C,  C_S, D, D_S, E, F, F_S,  G,   G_S,  A,  A_S,  B,
NOTE_TABLE_C3_R00: .byte 241, 213, 186,68, 21, 232, 191, 151, 114, 79, 46, 14    ;octave 3
NOTE_TABLE_C4_R00: .byte 248, 234, 221,162, 138, 116, 95, 75, 57, 39, 23, 7     ;octave 4
NOTE_TABLE_C5_R00: .byte 124, 117, 110,209, 197, 186, 175, 165, 156, 147, 139, 131   ;octave 5
NOTE_TABLE_C3_R01: .byte 3, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1
NOTE_TABLE_C4_R01: .byte   1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0      
NOTE_TABLE_C5_R01: .byte   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


MSG_ZUTA:      .byte "** Zebra   Music **",0
                     ;123456789ABCDEFGHIJK123456789ABCDEFGHIJK 

KEY_IS_PRESSED     = $2F

IS_WEAK = $2D
IS_WEAK_2 = $2C
NOTE_VECTOR_R0 = $10
NOTE_VECTOR_R1 = $12
CHANNEL_VOCTOR = $14

VOL = $30
Y_EACH_CHANNEL_BEGIN = $35

A_COUNT = $16
B_COUNT = $17
C_COUNT = $18
COUNT_VECTOR = $19

REG_VECTOR = $2B

Y_NOTE_TEMP = $2D
Y_NOTE_TEMP_1 = $20
Y_NOTE_TEMP_2 = $24
SHARP = $25
COUNT_TEMP = $26
ASCII_PATCH = $27

X_TEMP = $29

A_NOTE = $0A00
B_NOTE = $0B00
C_NOTE = $0C00

VRAM_BEGIN = $7338
MSGL = $21
MSGH = $22
OK_CHANNEL = $23


ZUTA:       LDA #$FF               ;clear screen
            STA $8020
            LDA #<MSG_ZUTA         ;show welcome screen
            STA MSGL
            LDA #>MSG_ZUTA
            STA MSGH
            JSR SHWMSG

            LDA #$20               ;set button states
            STA IS_WEAK
            LDA #$FF
            STA IS_WEAK_2

            LDA #$00
            STA VOL
            STA VOL+1
            STA VOL+2
           
;===========================================
            STA A_COUNT
            STA B_COUNT
            STA C_COUNT
;===========================================
            STA COUNT_VECTOR
            STA X_TEMP
         
            STA SHARP

           

            LDA #<NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1+1  

            LDA #<A_NOTE            ;default A Channel editer
            STA CHANNEL_VOCTOR
            LDA #>A_NOTE
            STA CHANNEL_VOCTOR+1 
 
            
            LDA #<A_COUNT
            STA COUNT_VECTOR
            LDA #>A_COUNT
            STA COUNT_VECTOR+1  

            
            LDA #$40
            STA ASCII_PATCH

            LDY #$00         
            
GET_NOTE:   LDA $8001
            CMP #$00
            BEQ GET_NOTE
            CMP #'p'
            BEQ PLAY_NOTE_0
            CMP #'8'
            BEQ SET_CHANNEL_A
            CMP #'9'
            BEQ SET_CHANNEL_B
            CMP #'0'
            BEQ SET_CHANNEL_C
            CMP #'d'
            BEQ BS_BUTTON_0
            
            STA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            INY
            JMP GET_NOTE



SET_CHANNEL_A: 
             
            JSR SAVE_COUNT
A_0:        LDA #$FF               ;clear screen
            STA $8020
            LDA #'A'
            STA $7310
            LDA #<A_NOTE
            STA CHANNEL_VOCTOR
            LDA #>A_NOTE
            STA CHANNEL_VOCTOR+1
           
            

            LDA #<A_COUNT
            STA COUNT_VECTOR
            LDA #>A_COUNT
            STA COUNT_VECTOR+1 
            
            LDY #$00
            JMP LIST_NOTE 

SET_CHANNEL_B: 
                       
B_0:        JSR SAVE_COUNT
            LDA #$FF               ;clear screen
            STA $8020
            LDA #'B'
            STA $7310
            LDA #<B_NOTE
            STA CHANNEL_VOCTOR
            LDA #>B_NOTE
            STA CHANNEL_VOCTOR+1
            
            

            LDA #<B_COUNT
            STA COUNT_VECTOR
            LDA #>B_COUNT
            STA COUNT_VECTOR+1 
            LDY #$00
            JMP LIST_NOTE 

PLAY_NOTE_0: 
            JSR SAVE_COUNT
            JMP INIT_PLAY_NOTE

BS_BUTTON_0: 
            JMP BS_BUTTON

SET_CHANNEL_C: 

C_0:        JSR SAVE_COUNT
            LDA #$FF               ;clear screen
            STA $8020
            LDA #'C'
            STA $7310
            LDA #<C_NOTE
            STA CHANNEL_VOCTOR
            LDA #>C_NOTE
            STA CHANNEL_VOCTOR+1
            
           
            
            LDA #<C_COUNT
            STA COUNT_VECTOR
            LDA #>C_COUNT
            STA COUNT_VECTOR+1 
            LDY #$00
            JMP LIST_NOTE  

SAVE_COUNT:
           
           TYA
           LDY #$00
           STA (COUNT_VECTOR),Y
           RTS

BS_BUTTON:  
            ;DEX
            DEY
            LDA #$20
            STA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            ;DEY
            JMP GET_NOTE



LIST_NOTE:  
            LDA (COUNT_VECTOR),Y
            CMP #$00
            BEQ RE_GET_NOTE
            
            STA COUNT_TEMP
            LDY #$00
            

LIST_LOOP:  LDA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            INY
            TYA 
            CMP COUNT_TEMP
            BCC LIST_LOOP
           
GET_NOTE_0:         
            JMP GET_NOTE


RE:
            LDY Y_NOTE_TEMP
RE_GET_NOTE:          
            LDA #'N'  ; debug
            STA $731E
            JMP GET_NOTE

BACK_TO_CHANNEL_A:
            LDA #$00
            STA $A008
            STA $A009
            STA $A00A
            JMP A_0

INIT_PLAY_NOTE:  ;STY Y_NOTE_TEMP
            LDA #$00      ; set channel A B C vol to zero
            STA $A008
            STA $A009
            STA $A00A
            LDA #$38      ;disable all channel
            STA $A007
            LDA #$00
            STA OK_CHANNEL
            STA Y_EACH_CHANNEL_BEGIN
            STA X_TEMP     ;AY TUNE register num


            LDA #'1'  ; debug
            STA $731E
            
              
GET_NEXT_CHANNEL:
            LDY #$00
            LDX #$00
            LDA OK_CHANNEL
            CMP #$03         
            BEQ GO_FOR_NEXT_NOTE_0    ;next note update Y_EACH_CHANNEL_BEGIN
    
            
PLAY_LOOP: 
            LDA #'S'  ; debug
            STA $731E
            
            
            LDY Y_EACH_CHANNEL_BEGIN   ;first time play Y=0 
        
           
FINISH_SET_OCTAVE: 

            LDA (CHANNEL_VOCTOR),Y
            CMP #'#'
            BEQ SET_SHARP
            CMP #$41 ;A-G           
            BCS SET_TONE         ; next channel
            CMP #'3'
            BEQ SET_OCTAVE_C3_0    
            CMP #'4'
            BEQ SET_OCTAVE_C4_0
            CMP #'5'
            BEQ SET_OCTAVE_C5_0
            CMP #'-'
            BEQ SET_PLAY_HOLD    ; next channel
            CMP #'.'
            BEQ SET_PLAY_OFF     ; next channel
            CMP #'@'
            BEQ BACK_TO_CHANNEL_A     ; next channel

            LDA #'E'  ; debug
            STA $7321
            
            JMP BACK_TO_CHANNEL_A

SET_TONE:   STY Y_EACH_CHANNEL_BEGIN  ;backup the Y 
            PHA                 ; A -> NOTE
            LDA #$0F
            LDX OK_CHANNEL
            STA VOL,X            ;set correct Channel Vol
            PLA                  ;recover note
            LDX X_TEMP
            
            SEC
            SBC #$41     ; the org TUNE
                       
            TAY
            LDA TUNE_PAD,Y   ;#
            CLC
            ADC SHARP
            TAY                 ;Y - the TUNE

            LDA (NOTE_VECTOR_R0),Y ; SET AY TUNE
            STA $A000,X
            INX
            LDA (NOTE_VECTOR_R1),Y
            STA $A000,X
            INX
            STX X_TEMP

        
            ;INY
            

            JMP NEXT_CHANNEL

GO_FOR_NEXT_NOTE_0: JMP GO_FOR_NEXT_NOTE

SET_PLAY_OFF:
            INC X_TEMP
            INC X_TEMP
            LDA #$00
            LDX OK_CHANNEL
            STA VOL,X
            INC OK_CHANNEL
            JMP NEXT_CHANNEL
            

SET_SHARP:

            LDA #$01
            STA SHARP
            INY
            JMP FINISH_SET_OCTAVE

NEXT_CHANNEL:

       
            LDA #$00
            STA SHARP
            

            INC CHANNEL_VOCTOR+1   ;next channel 0A 0B 0C
            INC OK_CHANNEL
           
            LDA #'P'  ; debug
            STA $731E
            
            JMP GET_NEXT_CHANNEL


SET_PLAY_HOLD:
            LDA #'H'   ;debug
            STA $7315

            INC X_TEMP
            INC X_TEMP
            INC OK_CHANNEL
            JMP NEXT_CHANNEL
            
SET_OCTAVE_C3_0: JMP SET_OCTAVE_C3
SET_OCTAVE_C4_0: JMP SET_OCTAVE_C4
SET_OCTAVE_C5_0: JMP SET_OCTAVE_C5




GO_FOR_NEXT_NOTE:


              LDA #$00
              STA X_TEMP

              JSR SET_VOL
             
              LDA #00
              STA OK_CHANNEL

              LDA #$0A
              STA CHANNEL_VOCTOR+1

              INC Y_EACH_CHANNEL_BEGIN

              LDA #'R'  ; debug
              STA $7320
              LDY #$00
              JMP PLAY_LOOP
            



  

SET_OCTAVE_C3:
           
            LDA #'3'   ;debug
            STA $7318

            LDA #<NOTE_TABLE_C3_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C3_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C3_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C3_R01
            STA NOTE_VECTOR_R1+1  
           
            INY
         
            JMP FINISH_SET_OCTAVE
SET_OCTAVE_C4:

             LDA #'4'   ;debug
            STA $7319
              LDA #<NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1+1  
           
            INY
          
            JMP FINISH_SET_OCTAVE
SET_OCTAVE_C5:
            LDA #'5'   ;debug
            STA $731A
            LDA #<NOTE_TABLE_C5_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C5_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C5_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C5_R01
            STA NOTE_VECTOR_R1+1  
    
            INY
            
            JMP FINISH_SET_OCTAVE





SET_VOL:
            LDA VOL
            STA $A008
            LDA VOL+1
            STA $A009
            LDA VOL+2
            STA $A00A
            LDA #$F8
            STA $A007

            LDA #'V'
            STA $7311

            JSR DELAY
            LDA #$20               ;set button states
            STA IS_WEAK
            LDA #$FF
            STA IS_WEAK_2

            RTS

          

DELAY: 
       LDA #$00
       CMP IS_WEAK
       BEQ OVER_DELAY
       ;DEC IS_WEAK
       
 DELAY_1:    
       CMP IS_WEAK_2
       BEQ DELAY_2
       DEC IS_WEAK_2
       JMP DELAY_1
DELAY_2:
       LDA #$FF
       STA IS_WEAK_2
       DEC IS_WEAK
       JMP DELAY
OVER_DELAY:
       RTS




SHWMSG:     LDY #$0
PRINT:      LDA (MSGL),Y
            BEQ DONE
            JSR ECHO
            INY
            BNE PRINT
DONE:       RTS
ECHO:       STA $8002
            RTS

