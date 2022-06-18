;
;         zTetris 
;
.org $BECA

POINT_L = $20
POINT_H = $21

PIVOT = $22

NOW_POINT_L = $23
NOW_POINT_H = $24

IS_CLEAR = $25

; SHAPE_PAD: .byte 
; 0_ROTATE_PAD: .byte '0x18','0x42'
; 1_ROTATE_PAD: .byte '0x19'

START:
        JSR INIT
        ;==============================
        LDA #$4D
        STA POINT_L
        STA NOW_POINT_L
        LDA #$71
        STA POINT_H
        STA NOW_POINT_H
        JSR SHAPE_DISPLAY
        LDA #$18              ;debug
        STA PIVOT
        LDA #$00
        STA IS_CLEAR
        ;===============================
        JSR DISPLAY_SHAPE


 GET_KEY:
       

    ;    CMP #'w'
    ;    BEQ ROTATE
       LDA $8001
       CMP #$00
       BEQ GET_KEY

       CMP #'s'
       BEQ DOWN
       CMP #'a'
       BEQ LEFT
       CMP #'d'
       BEQ RIGHT


DOWN:
        LDA #$18              ;debug
        STA PIVOT

        LDA #$FF
        STA IS_CLEAR
        JSR DISPLAY_SHAPE
        LDA #$00
        STA IS_CLEAR

        LDA NOW_POINT_L
        CLC
        ADC #$18
        BCC DOWN_1
        INC NOW_POINT_H
DOWN_1:
        STA NOW_POINT_L
        LDA #$18              ;debug
        STA PIVOT
        JSR DISPLAY_SHAPE
        JMP GET_KEY
LEFT:
RIGHT:






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

INIT:  
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



DISPLAY_SHAPE:

        LDA NOW_POINT_L
        STA POINT_L
        LDA NOW_POINT_H
        STA POINT_H

        ;0
        LDA POINT_L    
        SEC 
        SBC #$18
        BCS D0_1
        DEC POINT_H
D0_1:    STA POINT_L
        DEC POINT_L   ;-1

        CLC
        LSR PIVOT
        BCC D1
        JSR SHAPE_DISPLAY

        ;1
D1:     INC POINT_L
        LSR PIVOT
        BCC D2
        JSR SHAPE_DISPLAY

        ;2
D2:        INC POINT_L
        LSR PIVOT
        BCC D3
     JSR SHAPE_DISPLAY

        ;3
D3:     LDA NOW_POINT_L
        STA POINT_L
        DEC POINT_L
        CLC
        LSR PIVOT
        BCC D4
     JSR SHAPE_DISPLAY

        ;C
        INC POINT_L
        JSR SHAPE_DISPLAY

        ;4
D4:       
        INC POINT_L
        LSR PIVOT
        BCC D5
     JSR SHAPE_DISPLAY

        ;5
D5:     LDA NOW_POINT_L
        CLC
        ADC #$18
        BCC D5_1
        INC POINT_H
D5_1:    STA POINT_L

        CLC
        LSR PIVOT
        BCC D6
     JSR SHAPE_DISPLAY

        ;6
 D6:       INC POINT_L
        LSR PIVOT
        BCC D7
        JSR SHAPE_DISPLAY

        ;7
        INC POINT_L
        LSR PIVOT
        BCC D7
        JSR SHAPE_DISPLAY

D7:        RTS


