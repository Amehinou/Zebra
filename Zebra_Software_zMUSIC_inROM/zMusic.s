;=====================piano=====================
;
.org $BDA9

TUNE_PAD: .byte 1,1,0,1,1,1
REG_PAD:  .byte $0A,$0B,$0C
                         ; C,  C_S, D, D_S, E, F, F_S,  G,   G_S,  A,  A_S,  B,
NOTE_TABLE_C3_R00: .byte 68, 21, 232, 191, 151, 114, 79, 46, 14, 241, 213, 186    ;octave 3
NOTE_TABLE_C4_R00: .byte 162, 138, 116, 95, 75, 57, 39, 23, 7, 248, 234, 221     ;octave 4
NOTE_TABLE_C5_R00: .byte 209, 197, 186, 175, 165, 156, 147, 139, 131, 124, 117, 110  ;octave 5
NOTE_TABLE_C3_R01: .byte 3, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1
NOTE_TABLE_C4_R01: .byte   1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0      
NOTE_TABLE_C5_R01: .byte   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;KEY_PAD_CHAR: .byte 'A','W','S','E','D','F','T','G','Y','H','U','J','C','4'
;KEY_PAD_CHAR_LOW: .byte 'a','w','s','e','d','f','t','g','y','h','u','j','c','4'
;KEY_PAD_PIXEL: .byte $64,$51,$66,$53,$68,$69,$56,$6B,$58,$6D,$5A,$6F,$B8,$B9


MSG_ZUTA:      .byte "** Zebra   Music **",0
                     ;123456789ABCDEFGHIJK123456789ABCDEFGHIJK 

KEY_IS_PRESSED     = $2F

IS_WEAK = $2D
IS_WEAK_2 = $2C
NOTE_VECTOR_R0 = $10
NOTE_VECTOR_R1 = $12
CHANNEL_VOCTOR = $14

VOL_A = $30
VOL_B = $31
VOL_C = $32

A_COUNT = $16
B_COUNT = $17
C_COUNT = $18
COUNT_VECTOR = $19

REG_VECTOR = $2B

Y_NOTE_TEMP = $2D
Y_NOTE_TEMP_1 = $20
Y_NOTE_TEMP_2 = $24
SHARP = $25

A_NOTE = $0A00
B_NOTE = $0B00
C_NOTE = $0C00

VRAM_BEGIN = $734D
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

            LDA #$09               ;set button states
            STA IS_WEAK
            LDA #$FF
            STA IS_WEAK_2

            LDA #$00
            STA VOL_A
            STA VOL_B
            STA VOL_C
;===========================================
            STA A_COUNT
            STA B_COUNT
            STA C_COUNT
;===========================================
            STA COUNT_VECTOR
            STA REG_VECTOR

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
 
            LDA A_COUNT
            STA COUNT_VECTOR
            LDA #<A_COUNT
            STA COUNT_VECTOR
            LDA #>A_COUNT
            STA COUNT_VECTOR+1  

            LDA #$0A                 ;$0A00
            STA REG_VECTOR+1
            

            LDX #$00
            LDY #$00         
            
GET_NOTE:   LDA $8001
            CMP #$00
            BEQ GET_NOTE
            CMP #'p'
            BEQ PLAY_NOTE_0
            CMP #'a'
            BEQ SET_CHANNEL_A
            CMP #'b'
            BEQ SET_CHANNEL_B
            CMP #'c'
            BEQ SET_CHANNEL_C
            ; CMP #'N'
            ; BEQ NEW_NOTE
            CMP #'l'
            BEQ BS_BUTTON

            STA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            INY
            CLC
            STY Y_NOTE_TEMP
            LDA #$01
            ADC (COUNT_VECTOR),Y
            LDY Y_NOTE_TEMP
            JMP GET_NOTE



SET_CHANNEL_A: 
            LDA #$FF               ;clear screen
            STA $8020
            LDA #<A_NOTE
            STA CHANNEL_VOCTOR
            LDA #>A_NOTE
            STA CHANNEL_VOCTOR+1
           
            LDA #$0A
            STA REG_VECTOR+1

            LDA #<A_COUNT
            STA COUNT_VECTOR
            LDA #>A_COUNT
            STA COUNT_VECTOR+1 
            
            JMP LIST_NOTE 

SET_CHANNEL_B: 
            LDA #$FF               ;clear screen
            STA $8020
            LDA #<B_NOTE
            STA CHANNEL_VOCTOR
            LDA #>B_NOTE
            STA CHANNEL_VOCTOR+1 
            LDA #$0B
            STA REG_VECTOR+1

            LDA #<B_COUNT
            STA COUNT_VECTOR
            LDA #>B_COUNT
            STA COUNT_VECTOR+1 
            
            JMP LIST_NOTE 

PLAY_NOTE_0: JMP PLAY_NOTE

SET_CHANNEL_C: 
            LDA #$FF               ;clear screen
            STA $8020
            LDA #<C_NOTE
            STA CHANNEL_VOCTOR
            LDA #>C_NOTE
            STA CHANNEL_VOCTOR+1 
           LDA #$0C
            STA REG_VECTOR+1
            
            LDA #<C_COUNT
            STA COUNT_VECTOR
            LDA #>C_COUNT
            STA COUNT_VECTOR+1 
       
            JMP LIST_NOTE  



BS_BUTTON:  DEY
            DEC COUNT_VECTOR
            LDA #$20
            STA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            JMP GET_NOTE



LIST_NOTE:  
            LDA COUNT_VECTOR
            CMP #$00
            BEQ RE_GET_NOTE

            LDY #$00
LIST_LOOP:  LDA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            INY
            TYA 
            CMP COUNT_VECTOR
            BCC LIST_LOOP
            LDA (CHANNEL_VOCTOR),Y
            STA VRAM_BEGIN,Y
            JMP GET_NOTE



RE:
            LDY Y_NOTE_TEMP
RE_GET_NOTE:           JMP GET_NOTE


PLAY_NOTE:  STY Y_NOTE_TEMP
            LDA #$00
            STA $A008
            STA $A009
            STA $A00A
            LDA #$07
            STA $A007

GET_NEXT_CHANNEL:
            LDA OK_CHANNEL
            CMP #$02
            BEQ GO_FOR_NEXT_NOTE

            JSR NEXT_CHANNEL
            
            LDA COUNT_VECTOR
            CMP #$00
            BEQ RE_GET_NOTE

            ;LDY #$00
PLAY_LOOP:  LDA (CHANNEL_VOCTOR),Y
            CMP #'#'
            BEQ SET_PLAY_SHARP
            CMP #$41 ;A-G
            BCS SET_PLAY_NOTE
            CMP #'3'
            BEQ SET_OCTAVE_C3
            CMP #'4'
            BEQ SET_OCTAVE_C4
            CMP #'5'
            BEQ SET_OCTAVE_C5
            CMP #'-'
            BEQ SET_PLAY_HOLD
            CMP #'.'
            BEQ SET_PLAY_OFF

            JMP NEXT_CHANNEL



            INY
            TYA 
            CMP COUNT_VECTOR
            BCC PLAY_LOOP

            INC OK_CHANNEL
            JMP PLAY_NOTE

SET_PLAY_NOTE:
            STA Y_NOTE_TEMP
            JMP PLAY_LOOP


NEXT_CHANNEL:
            STY Y_NOTE_TEMP_1
            CLC
            LDA #$01
            ADC CHANNEL_VOCTOR+1
            STA CHANNEL_VOCTOR+1
            INC OK_CHANNEL
            LDY OK_CHANNEL
            LDA ($06),Y
            STA REG_VECTOR+1
            LDY Y_NOTE_TEMP_1
            
            RTI


SET_PLAY_HOLD:
            INC OK_CHANNEL
            


SET_PLAY_OFF:

SET_PLAY_SHARP:
            LDA #$01
            STA SHARP
            INY
            JMP PLAY_LOOP


GO_FOR_NEXT_NOTE:
            JSR SET_VOL
            INY 
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
            JMP TO_SET_AY_NOTE
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
              JMP TO_SET_AY_NOTE
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
              JMP TO_SET_AY_NOTE

TO_SET_AY_NOTE:



SET_VOL:
            LDA VOL_A
            STA $A008
            LDA VOL_B
            STA $A008
            LDA VOL_C
            STA $A008
            JSR DELAY

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
       RTI




SHWMSG:     LDY #$0
PRINT:      LDA (MSGL),Y
            BEQ DONE
            JSR ECHO
            INY
            BNE PRINT
DONE:       RTS
ECHO:       STA $8002
            RTS

