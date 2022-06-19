;
;         zTetris 
;
.org $BE3C


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

START:
        JSR INIT_MAP
        JSR GET_RANDOM_SHAPE
        JSR INIT_SHAPE
        JSR CORE_DISPLAY_LOOP
MAIN_LOOP:     
        JSR GET_KEY
        LDA IS_RESET
        CMP #$FF
        BEQ START
        JMP MAIN_LOOP

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

GET_RTS:    RTS

DOWN:
        
        JSR CLS_OLD_SHAPE
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
        JSR SHAPE_DISPLAY
       
        ;STA NOW_PIVOT
        LDA #$00
        STA IS_CLEAR
        STA ROTATE_NUM
        STA IS_RESET

        

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


 ;0
D0:     LDA POINT_L
        CLC
        ADC #$18
        BCC D0_1
        INC POINT_H
D0_1:   STA POINT_L
        DEC POINT_L
        CLC
        LSR PIVOT
        BCC D1
     JSR SHAPE_DISPLAY

        ;1
 D1:    INC POINT_L
        LSR PIVOT
        BCC D2
        JSR SHAPE_DISPLAY

        ;2
D2:     INC POINT_L
        LSR PIVOT
        BCC D3
        JSR SHAPE_DISPLAY
        ;3
D3:     
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

DC:
        DEC POINT_L
        JSR SHAPE_DISPLAY

D4:
        DEC POINT_L
        LSR PIVOT
        BCC D5
        JSR SHAPE_DISPLAY

D5:
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


D6:
        INC POINT_L
        LSR PIVOT
        BCC D7
        JSR SHAPE_DISPLAY

D7:
        INC POINT_L
        LSR PIVOT
        BCC DEND
        JSR SHAPE_DISPLAY

DEND:   RTS


CHECK_GAME_OVER:
       