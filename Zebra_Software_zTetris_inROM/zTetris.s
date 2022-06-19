;
;         zTetris 
;
.org $BC86



POINT_L = $20
POINT_H = $21

PIVOT = $22

NOW_POINT_L = $23
NOW_POINT_H = $24

IS_CLEAR = $25
ROTATE_NUM = $26
PIVOT_VEC = $27
IS_RESET = $29
IS_DOWN_BLK_EXIST = $30
IS_DOWN_BLK_SELF = $31



IS_DOWN = $32
NEXT_POINT_L = $33
NEXT_POINT_H = $34
IS_STOP = $35
IS_FIRST = $36
IS_INNER_BLK = $37

CHECK_L = $50
CHECK_H = $51
IS_NOT_FULL = $52
CHECK_LINE = $53
MOVE_L = $54
MOVE_H = $55
MOVE_LINE = $56
IS_WEAK = $57
IS_WEAK_2 = $58

START:
        JSR INIT_MAP
        JSR SET_COLOR
        LDA #$FF
       STA IS_WEAK_2
       LDA #$09
       STA IS_WEAK
NEXT_0:
         JSR GET_RANDOM_SHAPE
        JSR INIT_SHAPE
        ;JSR CORE_DISPLAY_LOOP
; MAIN_LOOP:     
;         JSR GET_KEY
;         LDA IS_RESET

;         CMP #$FF
;         BEQ START
;         LDA IS_STOP
;         CMP #$FF
;         BEQ NEXT

;         JMP MAIN_LOOP


DELAY: 
       LDA #$00
       CMP IS_WEAK
       BEQ OVER_DELAY
       ;DEC IS_WEAK
       
 DELAY_1:    
       CMP IS_WEAK_2
       BEQ DELAY_2
       DEC IS_WEAK_2

        JSR GET_KEY
        LDA IS_RESET

        CMP #$FF
        BEQ START
        LDA IS_STOP
        CMP #$FF
        BEQ NEXT

       JMP DELAY_1
DELAY_2:
       LDA #$FF
       STA IS_WEAK_2
       DEC IS_WEAK
       JMP DELAY
OVER_DELAY:
       JSR DOWN
       LDA #$09
       STA IS_WEAK
       JMP DELAY



 NEXT:

      JSR CHECK_LOOP
      JMP NEXT_0
        


CLS_OLD_SHAPE:
        LDA #$FF
        STA IS_CLEAR
        JSR CORE_DISPLAY_LOOP
        LDA #$00
        STA IS_CLEAR
        RTS


GET_KEY:
       

    
       LDA $8001
       CMP #$00
       BEQ GET_RTS

       CMP #'s'
       BEQ DOWN
       CMP #'a'
       BEQ LEFT
       CMP #'d'
       BEQ RIGHT
       CMP #'w'
       BEQ ROTATE
       CMP #'r'
       BEQ RESET
       CMP #'f'
       BEQ F1

GET_RTS:    RTS

F1:
     LDA #$01
     STA $8008
     JMP GET_RTS

DOWN:
        
        JSR CLS_OLD_SHAPE

        LDA #$FF
        STA IS_DOWN

        LDA NOW_POINT_L
        CLC
        ADC #$18
        BCC DOWN_1
        INC NOW_POINT_H
DOWN_1:
        STA NOW_POINT_L
       
        JSR CORE_DISPLAY_LOOP
        RTS
LEFT:
        JSR CLS_OLD_SHAPE
        DEC NOW_POINT_L
        JSR CORE_DISPLAY_LOOP
        RTS

RIGHT:
        JSR CLS_OLD_SHAPE
        INC NOW_POINT_L
        JSR CORE_DISPLAY_LOOP
        RTS

ROTATE:
        JSR CLS_OLD_SHAPE
        LDA ROTATE_NUM
        CMP #$03
        BEQ ROTATE_0
        INC ROTATE_NUM
        JMP ROTATE_1
ROTATE_0:
        LDA #$00
        STA ROTATE_NUM

ROTATE_1: 
        LDA #$FF
        STA IS_FIRST
        JSR CORE_DISPLAY_LOOP
        LDA #$00
        STA IS_FIRST
        RTS

RESET:
        LDA #$FF
        STA IS_RESET
        RTS



        
GET_RANDOM_SHAPE:
        LDA #<ROTATE_PAD_0
        STA PIVOT_VEC
        LDA #>ROTATE_PAD_0
        STA PIVOT_VEC+1

RANDOM:
        LDX #$00
        LDA $8003
        AND #$07
        CMP #$07
        BEQ RANDOM

        TAY
GET_RANDOM_SHAPE_0:
        LDA PIVOT_VEC
        CPY #$00
        BEQ GET_RANDOM_SHAPE_1
        CLC
        ADC #$04
        BCC GET_RANDOM_SHAPE_2
        INC PIVOT_VEC+1
GET_RANDOM_SHAPE_2:
        STA PIVOT_VEC
        DEY
        JMP GET_RANDOM_SHAPE_0
GET_RANDOM_SHAPE_1:
        RTS






INIT_SHAPE:
        LDA #$4D
        STA POINT_L
        STA NOW_POINT_L
        LDA #$71
        STA POINT_H
        STA NOW_POINT_H
        
       
        ;STA NOW_PIVOT
        LDA #$00
        STA IS_CLEAR
        STA ROTATE_NUM
        STA IS_RESET
        STA IS_DOWN
        STA IS_STOP
        STA IS_INNER_BLK
        STA IS_INNER_BLK+1
        STA IS_INNER_BLK+2
        STA IS_INNER_BLK+3
        STA IS_INNER_BLK+4
        STA IS_INNER_BLK+5
        STA IS_INNER_BLK+6
        STA IS_INNER_BLK+7


        LDA #$FF
        STA IS_FIRST
        JSR CORE_DISPLAY_LOOP
        LDA #$00
        STA IS_FIRST
        RTS



INIT_DISPLAY:
        LDY #$00
        LDA #$1F
        STA (POINT_L),Y
        LDY #$0C
        STA (POINT_L),Y
        LDY #$00
        RTS

INIT_DISPLAY_0:
        LDY #$00
        LDA #$1F
        STA (POINT_L),Y
        RTS

INIT_MAP:  
        LDA #$81
        STA $8020

        LDA #$01
        STA $8008

        LDA #$30
        STA POINT_L
        LDA #$71
        STA POINT_H

        LDY #$00
        LDX #$00
INIT_0:   
        JSR INIT_DISPLAY   
        CLC
        LDA POINT_L
        ADC #$18
        STA POINT_L
        
        
        LDA POINT_L
        CMP #$08
        BNE INIT_1
        INC POINT_H
       
INIT_1: 
        INX
        TXA
        CMP #$14
        BNE INIT_0

        LDX #$00
        LDA #$F7
        STA POINT_L
        LDA #$72
        STA POINT_H
INIT_2: 
        LDA POINT_L
        ADC #$01
        STA POINT_L
        JSR INIT_DISPLAY_0
        LDA POINT_L
        CMP #$FF
        BNE INIT_3
        INC POINT_H
 INIT_3:       
        INX
        TXA
        CMP #$0C
        BNE INIT_2

        RTS

SHAPE_DISPLAY:
        LDY #$00
        LDA IS_CLEAR
        CMP #$FF
        BNE SHAPE_1
        LDA #$00
        JMP SHAPE_2
SHAPE_1:
        LDA #$1F
SHAPE_2:
        STA (POINT_L),Y
        RTS





CORE_DISPLAY_LOOP:
        
        LDY ROTATE_NUM
        LDA NOW_POINT_L
        STA POINT_L
        LDA NOW_POINT_H
        STA POINT_H
        LDA (PIVOT_VEC),Y
        STA PIVOT

        LDX #$00
 ;0
D0:     LDA POINT_L
        CLC
        ADC #$18
        BCC D0_1
        INC POINT_H
D0_1:   
        DEC POINT_L
        STA POINT_L
        CLC
        LSR PIVOT
        BCC D1
        JSR SHAPE_DISPLAY
;===============================
        
        JSR CHECK_0_2
        

;===========================================
     

        ;1
 D1:    
        INX
        INC POINT_L
        LSR PIVOT
        BCC D2
        JSR SHAPE_DISPLAY
;=============================
       
        JSR CHECK_0_2
        

;===========================================
        

        ;2
D2:     
        INX
        INC POINT_L
        LSR PIVOT
        BCC D3
        JSR SHAPE_DISPLAY
;===========================
        
        JSR CHECK_0_2
        
;===========================================

        
        ;3
D3:     INX
        LDA POINT_L    
        SEC 
        SBC #$18
        BCS D3_1
        DEC POINT_H
D3_1:   STA POINT_L
        ;DEC POINT_L   ;-1
        CLC
        LSR PIVOT
        BCC DC
        JSR SHAPE_DISPLAY
        ;===============================
        
        JSR CHECK_3_7
        

;===========================================
        

DC:     INX
        DEC POINT_L
        JSR SHAPE_DISPLAY
          ;===============================
        
        JSR CHECK_3_7
        

;===========================================
        


D4:     INX
        DEC POINT_L
        LSR PIVOT
        BCC D5
         JSR SHAPE_DISPLAY
          ;===============================
        
        JSR CHECK_3_7
       

;===========================================
       

D5:     INX
        LDA POINT_L    
        SEC 
        SBC #$18
        BCS D5_1
        DEC POINT_H
D5_1:   STA POINT_L
        ;DEC POINT_L   ;-1
        CLC
        LSR PIVOT
        BCC D6
        JSR SHAPE_DISPLAY
          ;===============================
        
        JSR CHECK_3_7
       

;===========================================
        


D6:     INX
        INC POINT_L
        LSR PIVOT
        BCC D7
         JSR SHAPE_DISPLAY
          ;===============================
        
        ;JSR CHECK_3_7
        

;===========================================
       

D7:     INX
        INC POINT_L
        LSR PIVOT
        BCC DEND
        JSR SHAPE_DISPLAY
          ;===============================
        
        JSR CHECK_3_7
       

;===========================================
        

DEND:   
        
        RTS




 GET_NEXT_ADDRESS:
        

        LDA POINT_L
        STA NEXT_POINT_L
        LDA POINT_H
        STA NEXT_POINT_H
        LDA NEXT_POINT_L
        CLC
        ADC #$18
        BCC ADDRESS_1
        INC NEXT_POINT_H
ADDRESS_1:
        STA NEXT_POINT_L
        RTS


CHECK_0_2:
        
        JSR GET_NEXT_ADDRESS
        LDA IS_CLEAR
        CMP #$FF
        BEQ  NO_STOP
        LDA IS_FIRST
        CMP #$FF
        BEQ  NO_STOP
        
        LDY #$00
        LDA (NEXT_POINT_L),Y
        CMP #$1F 
        BEQ STOP 
        RTS
STOP:
        LDA #$FF
        STA IS_STOP
NO_STOP:       RTS


CHECK_3_7:

        
        JSR GET_NEXT_ADDRESS
        LDA IS_CLEAR
        CMP #$FF
        BEQ  NO_STOP
        
        LDA IS_FIRST
        CMP #$FF
        BEQ SET_INNER

        JMP CHECK_3_7_1   

SET_INNER:
        LDY #$00
        LDA (NEXT_POINT_L),Y
        CMP #$1F 
        BEQ SET_INNER_1
        JMP SET_INNER_2

SET_INNER_1:
        LDA #$FF
        STA IS_INNER_BLK,X
        JMP SET_INNER_3

SET_INNER_2:
        LDA #$00
        STA IS_INNER_BLK,X
 SET_INNER_3:
        RTS

CHECK_3_7_1:
        LDA IS_INNER_BLK,X
        CMP #$FF
        BEQ SET_NO_STOP

        LDY #$00
        LDA (NEXT_POINT_L),Y
        CMP #$1F 
        BEQ SETP_0
        JMP SET_NO_STOP 
SETP_0:   
        LDA #$FF
        STA IS_STOP
        
SET_NO_STOP:
        
        RTS


        

ROTATE_PAD_0: .byte $18,$42,$18,$42
ROTATE_PAD_1: .byte $38,$C2,$1C,$43
ROTATE_PAD_2: .byte $98,$46,$19,$62
ROTATE_PAD_3: .byte $0E,$0E,$0E,$0E
ROTATE_PAD_4: .byte $D0,$4C,$0B,$32
ROTATE_PAD_5: .byte $58,$4A,$1A,$52
ROTATE_PAD_6: .byte $68,$8A,$16,$51



CHECK_LOOP:

        LDA #$00
        STA CHECK_LINE
        LDA #$E1
        STA CHECK_L
        LDA #$72
        STA CHECK_H

        LDY #$00
C_LOOP:
        LDA (CHECK_L),Y
        CMP #$00 
        BEQ NOT_FULL
C_LOOP_3:
        INY
        CPY #$0B
        BEQ DELETE_LINE
        JMP C_LOOP
NOT_FULL:
        LDA #$FF
        STA IS_NOT_FULL
        JMP C_LOOP_3

NEXT_LINE:
        LDA CHECK_LINE
        CMP #$07
        BEQ CHECK_FINISH
        INC CHECK_LINE
        LDY #$00
         
         LDA CHECK_L
         SEC
         SBC #$18
         BCS C_LOOP_1
         INC CHECK_H
C_LOOP_1:
         STA CHECK_L
         JMP C_LOOP
         

CHECK_FINISH:
        RTS


DELETE_LINE:
        LDA IS_NOT_FULL
        CMP #$FF
        BEQ FINISH_DELETE

        LDY #$00
C_LOOP_2:
        LDA #$00
        STA (CHECK_L),Y
        INY
        CPY #$0B
        BEQ MOVE
        JMP C_LOOP_2
        

FINISH_DELETE:
        LDA #$00
        STA IS_NOT_FULL
        JMP NEXT_LINE


MOVE:
        LDA CHECK_L
        STA MOVE_L
        LDA CHECK_H
        STA MOVE_H
        
        LDA #$0F
        SEC
        SBC CHECK_LINE
        STA MOVE_LINE


NEXT_MOVE_0:
        LDA MOVE_LINE
        CMP #$07
        BEQ CHECK_LOOP
        DEC MOVE_LINE



         LDA MOVE_L
         SEC
         SBC #$18
         BCS C_LOOP_4
         INC MOVE_H
C_LOOP_4:
         STA MOVE_L

         LDY #$00
C_LOOP_5:
         LDA (MOVE_L),Y
         STA (CHECK_L),Y
         INY
         CPY #$0B
         BEQ NEXT_MOVE
         JMP C_LOOP_5


NEXT_MOVE:
         LDA CHECK_L
         SEC
         SBC #$18
         BCS C_LOOP_6
         INC CHECK_H
C_LOOP_6:
         STA CHECK_L
         JMP NEXT_MOVE_0




SET_COLOR:
        LDY #$00

 S_C:
        CPY #$05
        BEQ S_C_0
        LDA #$05
        STA $7110,Y
        LDA #$04
        STA $7115,Y
        LDA #$05
        STA $711A,Y
        LDA #$04
        STA $711F,Y
        
         INY
         JMP S_C

S_C_0:
        RTS