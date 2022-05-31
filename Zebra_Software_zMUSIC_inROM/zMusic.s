;=====================piano=====================
;
.org $BD25

TUNE_PAD: .byte 1,1,0,1,1,1

                         ; C,  C_S, D, D_S, E, F, F_S,  G,   G_S,  A,  A_S,  B,
NOTE_TABLE_C3_R00: .byte 241, 213, 186,68, 21, 232, 191, 151, 114, 79, 46, 14    ;octave 3
NOTE_TABLE_C4_R00: .byte 248, 234, 221,162, 138, 116, 95, 75, 57, 39, 23, 7     ;octave 4
NOTE_TABLE_C5_R00: .byte 124, 117, 110,209, 197, 186, 175, 165, 156, 147, 139, 131   ;octave 5
NOTE_TABLE_C3_R01: .byte 3, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1
NOTE_TABLE_C4_R01: .byte   1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0      
NOTE_TABLE_C5_R01: .byte   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;KEY_PAD_CHAR: .byte 'A','W','S','E','D','F','T','G','Y','H','U','J','C','4'
;KEY_PAD_CHAR_LOW: .byte 'a','w','s','e','d','f','t','g','y','h','u','j','c','4'
;KEY_PAD_PIXEL: .byte $64,$51,$66,$53,$68,$69,$56,$6B,$58,$6D,$5A,$6F,$B8,$B9
;REG_PAD: .byte $00,$A0,$01,$A0,$02,$A0,$03,$A0,$04,$A0,$05,$A0

MSG_ZUTA:      .byte "** Zebra   Music **",0
                     ;123456789ABCDEFGHIJK123456789ABCDEFGHIJK 

KEY_IS_PRESSED     = $2F

IS_WEAK = $2D
IS_WEAK_2 = $2C
NOTE_VECTOR_R0 = $10
NOTE_VECTOR_R1 = $12
CHANNEL_VOCTOR = $14

VOL = $30


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
SUM_CHAR = $28
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

            LDA #$90               ;set button states
            STA IS_WEAK
            LDA #$FF
            STA IS_WEAK_2

            LDA #$00
            STA VOL
           
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

       ;      LDA #<REG_PAD               
       ;      STA REG_VECTOR
       ;      LDA #>REG_PAD               
       ;      STA REG_VECTOR+1
            
            LDA #$40
            STA ASCII_PATCH

            ;LDX #$00
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
            ; CMP #'N'
            ; BEQ NEW_NOTE
            CMP #'d'
            BEQ BS_BUTTON_0
            
            ;INX
            STA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            INY
            JMP GET_NOTE



SET_CHANNEL_A: 
            LDA COUNT_VECTOR+1
            CMP #$16
            BNE A_0
            DEY    
A_0:        JSR SAVE_COUNT
            LDA #$FF               ;clear screen
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
            
            JMP LIST_NOTE 

SET_CHANNEL_B: 
            LDA COUNT_VECTOR+1
            CMP #$17
            BNE B_0
            DEY
            
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
            
            JMP LIST_NOTE 

PLAY_NOTE_0: JMP INIT_PLAY_NOTE
BS_BUTTON_0: JMP BS_BUTTON

SET_CHANNEL_C: 
            LDA COUNT_VECTOR+1
            CMP #$18
            BNE C_0
            DEY    

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

GET_NOTE_0: JMP GET_NOTE

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
            ;LDA (CHANNEL_VOCTOR),Y
            ;STA VRAM_BEGIN,Y
            ;INY
            ;LDY COUNT_TEMP
            JMP GET_NOTE



RE:
            LDY Y_NOTE_TEMP
RE_GET_NOTE:           JMP GET_NOTE


INIT_PLAY_NOTE:  ;STY Y_NOTE_TEMP
            LDA #$00      ; set channel A B C vol to zero
            STA $A008
            STA $A009
            STA $A00A
            LDA #$38      ;disable all channel
            STA $A007
              LDA #$00
              STA OK_CHANNEL

            LDA #<A_COUNT  ;only A COUNT is use for play
            STA COUNT_VECTOR
            LDA #>A_COUNT
            STA COUNT_VECTOR+1 

              
GET_NEXT_CHANNEL:
            LDY #$00
            LDX #$00
            LDA OK_CHANNEL
            CMP #$03
            BEQ GO_FOR_NEXT_NOTE_0

            ;LDY Y_EACH_CHANNEL_BEGIN

            ;JSR NEXT_CHANNEL
            
PLAY_LOOP:  LDA (COUNT_VECTOR),Y
            STA SUM_CHAR
            ; CMP FINISH_CHAR
            ; BEQ GET_NOTE_0
            LDY Y_EACH_CHANNEL_BEGIN
            ;LDY #$00
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

            ;JMP NEXT_CHANNEL
            ;====================================================
            INY
            TYA 
            CMP SUM_CHAR
            BEQ GET_NOTE_0
            JMP PLAY_LOOP
           

SET_TONE:   STY Y_NOTE_TEMP_1  ;backup the Y 
            PHA                 ; A -> NOTE
            LDA #$0F
            ;LDX #$00
            STA VOL,X            ;set Channel Vol

            LDX X_TEMP
            PLA
            SEC
            SBC #$41     ; the org TUNE
                       
            TAY
            LDA TUNE_PAD,Y
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

SET_SHARP:
             LDA #'S'   ;debug
            STA $7313

            LDA #$01
            STA SHARP
            INY
            JMP PLAY_LOOP

NEXT_CHANNEL:

            ;   LDA #$FF
            ; STA $8020
            ;STY Y_NOTE_TEMP_1

            LDA #'C'   ;debug
            STA $7311

            LDA #$00
            STA SHARP
            

            CLC
            LDA #$01
            ADC CHANNEL_VOCTOR+1
            STA CHANNEL_VOCTOR+1   ;next channel 0A 0B 0C

            INC OK_CHANNEL
           
        
            
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

SET_PLAY_OFF:
            INC X_TEMP
            INC X_TEMP
            LDA #$00
            LDX OK_CHANNEL
            STA VOL,X
            INC OK_CHANNEL
            JMP NEXT_CHANNEL




GO_FOR_NEXT_NOTE:
              LDA #$00
              STA X_TEMP

              JSR SET_VOL
            
              ;INC FINISH_CHAR
              LDA #00
              STA OK_CHANNEL
              JMP GET_NEXT_CHANNEL
            



  

SET_OCTAVE_C3:
           
             
            LDA #<NOTE_TABLE_C3_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C3_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C3_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C3_R01
            STA NOTE_VECTOR_R1+1  
            ; LDA #$33
            ; STA $73B9
            INY
            ;INC FINISH_CHAR
            JMP FINISH_SET_OCTAVE
SET_OCTAVE_C4:
              LDA #<NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1+1  
            ; LDA #$34
            ; STA $73B9
            INY
            ;INC FINISH_CHAR
              JMP FINISH_SET_OCTAVE
SET_OCTAVE_C5:
            LDA #<NOTE_TABLE_C5_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C5_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C5_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C5_R01
            STA NOTE_VECTOR_R1+1  
            ; LDA #$35
            ; STA $73B9
            INY
            ;INC FINISH_CHAR
              JMP FINISH_SET_OCTAVE





SET_VOL:
            LDA VOL
            STA $A008
            LDA VOL+1
            STA $A009
            LDA VOL+2
            STA $A00A
            LDA #$08
            STA $A007

            LDA #'V'
            STA $7311

            JSR DELAY
            RTS

DELAY: 
       LDA #$00
       CMP IS_WEAK
       DEC IS_WEAK
       BEQ OVER_DELAY
       
 DELAY_1:    
       CMP IS_WEAK_2
       BEQ DELAY
       DEC IS_WEAK_2
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

