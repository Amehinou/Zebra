;
;         zTetris 
;
.org $BDB4


ROTATE_PAD_0: .byte $18,$42,$18,$42
ROTATE_PAD_1: .byte $38,$C2,$1C,$43
ROTATE_PAD_2: .byte $98,$46,$19,$62
ROTATE_PAD_3: .byte $0E,$0E,$0E,$0E
ROTATE_PAD_4: .byte $D0,$4C,$0B,$32
ROTATE_PAD_5: .byte $58,$4A,$1A,$52
ROTATE_PAD_6: .byte $68,$8A,$16,$51

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
OLD_POINT_L = $32
OLD_POINT_H = $33
NOW_POINT_L_0 = $34
NOW_POINT_H_0 = $35

NEXT_POINT_L = $40
NEXT_POINT_H = $41
IS_STOP = $42
IS_FIRST = $43
INNER = $44

START:
        JSR INIT_MAP
NEXT:
        JSR GET_RANDOM_SHAPE
        JSR INIT_SHAPE
        JSR CORE_DISPLAY_LOOP
        
MAIN_LOOP:     
        JSR GET_KEY
        LDA IS_RESET
        CMP #$FF
        BEQ START
        LDA IS_STOP
        CMP #$FF
        BEQ NEXT
        JMP MAIN_LOOP

CLS_OLD_SHAPE:
        LDA OLD_POINT_L
        STA NOW_POINT_L
        LDA OLD_POINT_H
        STA NOW_POINT_H
        LDA #$FF
        STA IS_CLEAR
        JSR CORE_DISPLAY_LOOP
        LDA #$00
        STA IS_CLEAR
        
        LDA NOW_POINT_L_0
        STA NOW_POINT_L
        LDA NOW_POINT_H_0
        STA NOW_POINT_H
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
        LDA NOW_POINT_L
        STA OLD_POINT_L
        LDA NOW_POINT_H
        STA OLD_POINT_H
        
        LDA NOW_POINT_L
        CLC
        ADC #$18
        BCC DOWN_1
        INC NOW_POINT_H
DOWN_1:
        STA NOW_POINT_L
       
        JSR CORE_DISPLAY_LOOP
        
        LDA NOW_POINT_L_0
        STA NOW_POINT_L
        LDA NOW_POINT_H_0
        STA NOW_POINT_H
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
        JSR CORE_DISPLAY_LOOP
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
        JSR CORE_DISPLAY_LOOP
       
        ;STA NOW_PIVOT
        LDA #$00
        STA IS_CLEAR
        STA ROTATE_NUM
        STA IS_RESET
        STA IS_STOP

        STA INNER
        STA INNER+1
        STA INNER+2
        STA INNER+3
        STA INNER+4
        STA INNER+5
        STA INNER+6
        STA INNER+7



        LDA #$FF
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
D0:     
        LDA POINT_L
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
        ;=======================!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D0_N
        
; D0_Y:   JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
;         BEQ DEND_0
        
        ;=======================
D0_N:   JSR SHAPE_DISPLAY

        ;1
 D1:    INX
       
        INC POINT_L
        LSR PIVOT
        BCC D2
        ;=======================!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D1_N

; D1_Y:        JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
;         BEQ DEND_0
        
        ;=======================
D1_N:        JSR SHAPE_DISPLAY

        ;2
D2:    INX
        
        INC POINT_L
        LSR PIVOT
        BCC D3
        ;=======================!!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D2_N

; D2_Y:        JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
;         BEQ DEND_0
        
        ;=======================
D2_N:        JSR SHAPE_DISPLAY
        ;3
D3:     
        INX
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
        ;=======================!!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D3_N
;         LDA IS_FIRST
;         CMP #$FF
;         BNE D3_NO_INNER 
;         INC INNER,X
;         JMP D3_N
; D3_NO_INNER:
;         JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
;         BEQ DEND_0
        
        ;=======================
D3_N:
        JSR SHAPE_DISPLAY

DEND_0: JMP DEND

DC:
        INX
        DEC POINT_L
        ;=======================!!!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ DC_N
;         LDA IS_FIRST
;         CMP #$FF
;         BNE DC_NO_INNER 
;         INC INNER,X
;         JMP DC_N
; DC_NO_INNER:
;         JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
        BEQ DEND_0
        
        ;=======================
 DC_N:        JSR SHAPE_DISPLAY



D4:
        INX
        DEC POINT_L
        LSR PIVOT
        BCC D5
        ;=======================!!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D4_N
;         LDA IS_FIRST
;         CMP #$FF
;         BNE D4_NO_INNER 
;         INC INNER,X
;         JMP D4_N
; D4_NO_INNER:
;         JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
;         BEQ DEND
        
        ;=======================
 D4_N:        JSR SHAPE_DISPLAY



D5:
        INX
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
        ;=======================!!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D5_N
;         LDA IS_FIRST
;         CMP #$FF
;         BNE D5_NO_INNER 
;         INC INNER,X
;         JMP D5_N
; D5_NO_INNER:
;         JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
        BEQ DEND
        
        ;=======================
D5_N:         JSR SHAPE_DISPLAY


D6:
        INX
        INC POINT_L
        LSR PIVOT
        BCC D7
        ;=======================!!!!!!!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D6_N
;         LDA IS_FIRST
;         CMP #$FF
;         BNE D6_NO_INNER 
;         INC INNER,X
;         JMP D6_N
; D6_NO_INNER:
;         JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
;         BEQ DEND
        
        ;=======================
 D6_N:        JSR SHAPE_DISPLAY

D7:
        INX
        INC POINT_L
        LSR PIVOT
        BCC DEND
        ;=======================!!!!!!!!!!!!!!
;         LDA IS_CLEAR
;         CMP #$FF
;         BEQ D7_N
;         LDA IS_FIRST
;         CMP #$FF
;         BNE D7_NO_INNER 
;         INC INNER,X
;         JMP D7_N
; D7_NO_INNER:
;         JSR CHECK_BLK 
;         LDA IS_STOP
;         CMP #$FF
;         BEQ DEND
        
        ;=======================
D7_N:        JSR SHAPE_DISPLAY

DEND:   
        
        RTS


CHECK_BLK:
       
        RTS

        LDA POINT_L
        STA NEXT_POINT_L
        LDA POINT_H
        STA NEXT_POINT_H

        

        LDA NEXT_POINT_L
        CLC
        ADC #$18
        BCC CHECK_BLK_1
        INC NEXT_POINT_H
CHECK_BLK_1:
        STA NEXT_POINT_L
       
        LDY #$00
        LDA (NEXT_POINT_L),Y
        CMP #$1F 
        BEQ STOP 


        RTS

STOP:   
        CPX #$03
        BCC NO_STOP_1
        LDA INNER,X
        CMP #$00
        BNE NO_STOP
        LDA #$FF
        STA IS_STOP
        RTS

NO_STOP:
        DEC INNER,X
NO_STOP_1:
        RTS

        
       