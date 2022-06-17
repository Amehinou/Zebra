;
;            zPixel
;

.org $BF2C

POINT_L = $20
POINT_H = $21
IS_DRAW = $22


LINE_COLOR_VEC = $23

VRAM_BEGIN = $7324

            
START:  
        LDA #$81
        STA $8020
    
        LDA #$30
        STA POINT_L
        LDA #$71
        STA POINT_H
        JSR SET_POINT

GET_KEY:
       LDA $8001
       CMP #$00
       BEQ GET_KEY

       CMP #'w'
       BEQ UP
       CMP #'s'
       BEQ DOWN
       CMP #'a'
       BEQ LEFT
       CMP #'d'
       BEQ RIGHT
       CMP #' '
       BEQ DRAW
       CMP #'e'
       BEQ ERASER
       CMP #'n'
       BEQ FLASH_VRAM
       CMP #$30 ;0          
       BCS SET_LINE_COLOR 
    ;    CMP #'`'
    ;    BEQ LOAD
    ;    CMP #'='
    ;    BEQ SAVE

       JMP GET_KEY

UP:
      
       JSR SET_OLD_POINT
       
       LDA POINT_L
       CMP #$18
       BCC SUB_POINT_H
       
UP_0:  SEC
       SBC #$18
       STA POINT_L
       JSR SET_POINT
       JMP GET_KEY

SUB_POINT_H:
       DEC POINT_H
       JMP UP_0

DOWN:  
       JSR SET_OLD_POINT
       CLC
       LDA POINT_L
       ADC #$18
       BCC NOT_ADD_POINT_H
       INC POINT_H
NOT_ADD_POINT_H:      
       STA POINT_L
       JSR SET_POINT
       JMP GET_KEY

RIGHT:
       JSR SET_OLD_POINT
       CLC
       LDA POINT_L
       ADC #$01
       BCC RIGHT_0
       INC POINT_H
RIGHT_0:
       STA POINT_L
       JSR SET_POINT
       JMP GET_KEY

ERASER:   JMP ERASER_0
DRAW:   JMP DRAW_0
FLASH_VRAM: JMP FLASH_VRAM_0
SET_LINE_COLOR: JMP SET_LINE_COLOR_0

LEFT:
      JSR SET_OLD_POINT

      LDA POINT_L
      CMP #$00
      BNE LEFT_0
      DEC POINT_H
LEFT_0:
      SEC
      SBC #$01
      STA POINT_L
      JSR SET_POINT
      JMP GET_KEY

SET_POINT:
       LDY #$00
       LDA (POINT_L),Y
       CMP #$1F 
       BEQ SET_0
       
       LDA #$1F
       STA (POINT_L),Y
       RTS

SET_0:
       LDA #$FF
       STA IS_DRAW
       RTS
      
      

SET_OLD_POINT:
      LDY #$00
      LDA IS_DRAW
      CMP #$FF
      BEQ RECOVER_DRAW
      LDA #$00
      STA (POINT_L),Y
RECOVER_DRAW:
      STY IS_DRAW
      RTS
      

DRAW_0:

     LDA #$FF
     STA IS_DRAW
     JMP GET_KEY

ERASER_0:

     LDA #$00
     STA IS_DRAW
     JMP GET_KEY

FLASH_VRAM_0:
     ;LDA #$80
     ;STA $8020
     
     LDA #$01
     STA $8008

     ;LDA #$81
     ;STA $8020
     JMP START

SET_LINE_COLOR_0:
     