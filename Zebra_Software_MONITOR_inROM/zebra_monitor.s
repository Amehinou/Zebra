;  The Mai Monitor for Zebra Homebrew Computer 
;  Written by @Earture in 2021 modified by 


; Lines with comments starting with "*" indicate code changes from the original WozMon.




KBD         = $8001          ; PIA.A keyboard input
KBDCR       = $8011
DSP         = $8002          ; PIA.B display output register
DSPCR       = $8012

; Page 0 Variables

IN          = $0200          ;*Input buffer
XAML        = $24            ;*Index pointers
XAMH        = $25
STL         = $26
STH         = $27
L           = $28
H           = $29
YSAV        = $2A
MODE        = $2B
MSGL        = $2C
MSGH        = $2D
COUNTER     = $2E

; ZUTA
MARK         = $0A
OCTAVE       = $0B
NOTE         = $0C



           .org $EBFB
              

RESET:      CLD             ; Clear decimal arithmetic mode.
            CLI

           
           
            LDA #$FF        ; clear screen
            STA $8020

           
           
            LDA #<MSG1
            STA MSGL
            LDA #>MSG1
            STA MSGH
            JSR SHWMSG      ;* Show Welcome.
           
SOFTRESET:  LDA #$9B        ;* Auto escape.
NOTCR:      CMP #$88        ;* "<-"? Note this was changed to $88 which is the back space key.
            BEQ BACKSPACE   ; Yes.
            CMP #$9B        ; ESC?
            BEQ ESCAPE      ; Yes.
            INY             ; Advance text index.
            BPL NEXTCHAR    ; Auto ESC if >127.
ESCAPE:     LDA #<MSG_READY
            STA MSGL
            LDA #>MSG_READY
            STA MSGH
            JSR SHWMSG      ;* Show Ready.
GETLINE:    LDA #$0A        ; CR.
            JSR ECHO        ; Output it.
            LDY #$01        ; Initiallize text index.
BACKSPACE:  DEY             ; Backup text index.
            BMI GETLINE     ; Beyond start of line, reinitialize.
            LDA #$A0        ;*Space, overwrite the backspaced char.
            JSR ECHO
            LDA #$FF        ;*Backspace again to get to correct pos.========================
            JSR ECHO


NEXTCHAR:   
            LDA KBD         ; Load character. B7 should be ‘1’.
            CMP #$00
            BEQ NEXTCHAR

            CMP #$60        ;*Is it Lower case
            BMI   CONVERT   ;*Nope, just convert it
            AND #$5F        ;*If lower case, convert to Upper case
CONVERT:    ORA #$80        ;*Convert it to "ASCII Keyboard" Input
            STA IN,Y        ; Add to text buffer.
            JSR ECHO        ; Display character.
            CMP #$8D        ; CR?
            BNE NOTCR       ; No.
            LDY #$FF        ; Reset text index.
            LDA #$00        ; For XAM mode.
            TAX             ; 0->X.
SETSTOR:    ASL             ; Leaves $7B if setting STOR mode.
SETMODE:    STA MODE        ; $00 = XAM, $7B = STOR, $AE = BLOK XAM.
BLSKIP:     INY             ; Advance text index.
NEXTITEM:   LDA IN,Y        ; Get charcter.
            CMP #$8D        ; CR?
            BEQ GETLINE     ; Yes, done this line.
            CMP #$AE        ; "."?
            BCC BLSKIP      ; Skip delimiter.
            BEQ SETMODE     ; Set BLOCK XAM mode.
            CMP #$BA        ; ":"?
            BEQ SETSTOR     ; Yes, set STOR mode.
            CMP #$D2        ; "R"?
            BEQ RUN         ; Yes, run user program.  =================================================menu
            CMP #'K'+$80   ;
            BEQ ZEBRA_ASS       ;
            CMP #'I'+$80   ;
            BEQ LOGO
            CMP #'M'+$80   ; msbasic
            BEQ MSBASIC
            CMP #'X'+$80   ; user program 
            BEQ USER_FUNC
            CMP #'V'+$80   ; color
            BEQ MY_COLOR
           
           
            
            STX L           ; $00->L.
            STX H           ; and H.
            STY YSAV        ; Save Y for comparison.
NEXTHEX:     LDA IN,Y       ; Get character for hex test.
            EOR #$B0        ; Map digits to $0-9.                        B0: 1011 0000
            CMP #$0A        ; Digit?
            BCC DIG         ; Yes.
            ADC #$88        ; Map letter "A"-"F" to $FA-FF.
            CMP #$FA        ; Hex letter?
            BCC NOTHEX      ; No, character not hex.
DIG:        ASL
            ASL             ; Hex digit to MSD of A.
            ASL
            ASL
            LDX #$04        ; Shift count.
HEXSHIFT:   ASL             ; Hex digit left MSB to carry.
            ROL L           ; Rotate into LSD.
            ROL H           ; Rotate into MSD's.
            DEX             ; Done 4 shifts?
            BNE HEXSHIFT    ; No, loop.
            INY             ; Advance text index.
            BNE NEXTHEX     ; Always taken. Check next character for hex.
NOTHEX:     CPY YSAV        ; Check if L, H empty (no hex digits).
            BNE NOESCAPE    ;* Branch out of range, had to improvise...
            JMP ESCAPE      ; Yes, generate ESC sequence.

RUN:        JSR ACTRUN      ;* JSR to the Address we want to run.
            JMP   SOFTRESET ;* When returned for the program, reset EWOZ.
ACTRUN:     JMP (XAML)      ; Run at current XAM index.



ZEBRA_CLS:  JMP ZEBRA_CLS1

ZEBRA_ASS:
            JSR ZEBRA_CLS
            JMP $F000

LOGO:       JMP LOGO1

USER_FUNC:  JMP USER_FUNC1
MY_COLOR:  JMP MY_COLOR1
MSBASIC:    JMP MSBASIC1

NOESCAPE:   BIT MODE        ; Test MODE byte.
            BVC NOTSTOR     ; B6=0 for STOR, 1 for XAM and BLOCK XAM
            LDA L           ; LSD's of hex data.
            STA (STL, X)    ; Store at current "store index".
            INC STL         ; Increment store index.
            BNE NEXTITEM    ; Get next item. (no carry).
            INC STH         ; Add carry to 'store index' high order.
TONEXTITEM: JMP NEXTITEM    ; Get next command item.
NOTSTOR:    BMI XAMNEXT     ; B7=0 for XAM, 1 for BLOCK XAM.
            LDX #$02        ; Byte count.
SETADR:     LDA L-1,X       ; Copy hex data to
            STA STL-1,X     ; "store index".
            STA XAML-1,X    ; And to "XAM index'.
            DEX             ; Next of 2 bytes.
            BNE SETADR      ; Loop unless X = 0.
NXTPRNT:    BNE PRDATA      ; NE means no address to print.
            LDA #$0A        ; CR.
            JSR ECHO        ; Output it.
            LDA XAMH        ; 'Examine index' high-order byte.
            JSR PRBYTE      ; Output it in hex format.
            LDA XAML        ; Low-order "examine index" byte.
            JSR PRBYTE      ; Output it in hex format.
            LDA #$BA        ; ":".
            JSR ECHO        ; Output it.
PRDATA:     LDA #$A0        ; Blank.
            JSR ECHO        ; Output it.
            LDA (XAML,X)    ; Get data byte at 'examine index".
            JSR PRBYTE      ; Output it in hex format.
XAMNEXT:    STX MODE        ; 0-> MODE (XAM mode).
            LDA XAML
            CMP L           ; Compare 'examine index" to hex data.
            LDA XAMH
            SBC H
            BCS TONEXTITEM  ; Not less, so no more data to output.
            INC XAML
            BNE MOD8CHK     ; Increment 'examine index".
            INC XAMH
MOD8CHK:    LDA XAML        ; Check low-order 'exainine index' byte
            AND #$03        ; For MOD 8=0 ** changed to $0F to get 16 values per row **
            BPL NXTPRNT     ; Always taken.
PRBYTE:     PHA             ; Save A for LSD.
            LSR
            LSR
            LSR             ; MSD to LSD position.
            LSR
            JSR PRHEX       ; Output hex digit.
            PLA             ; Restore A.
PRHEX:      AND #$0F        ; Mask LSD for hex print.
            ORA #$B0        ; Add "0".
            CMP #$BA        ; Digit?
            BCC ECHO        ; Yes, output it.
            ADC #$06        ; Add offset for letter.
ECHO:       PHA             ;*Save A
            AND #$7F        ;*Change to "standard ASCII"


            STA DSP         ; Output character. Sets DA.

            PLA             ;*Restore A
            RTS             ;*Done, over and out...

ZEBRA_CLS1:
            PHA
            LDA #$FF        ; clear screen
            STA $8020
            PLA
            RTS
            
USER_FUNC1:
            
            JMP  $9000
       

MY_COLOR1:
            LDA  #$1F
            STA  $710D
            LDA  #$90
            STA  $710E
            LDA  #$0E
            STA  $710F
            LDA  #$01
            STA  $8005
            JMP  SOFTRESET

MSBASIC1:
            JSR ZEBRA_CLS
            JMP $DF58
           


SHWMSG:     LDY #$0
PRINT:      LDA (MSGL),Y
            BEQ DONE
            JSR ECHO
            INY
            BNE PRINT
DONE:       RTS

LOGO1:      LDA #$FF
            STA $8020
            LDA #<MSG2
            STA MSGL
            LDA #>MSG2
            STA MSGH
            JSR SHWMSG
LOGO_LP:    LDA KBD
            CMP #$00
            BEQ LOGO_LP
            JMP RESET

       
MSG_READY: .byte "Ready",0

MSG1:      .byte "** Zebra Monitor **    32K RAM System   ",0
                 ;123456789ABCDEFGHIJK123456789ABCDEFGHIJK       
MSG2:      ;.byte "^^^^^^^^^^^^^^^^^^^^"
           .byte "*       (>_^)      *"
           .byte "*                  *"
           .byte "*       Zebra      *"
           .byte "*       v1.00      *"
           .byte "*                  *"
           .byte "* HomebrewComputer *"
           .byte "*                  *"
           .byte "*      Earture     *"
           .byte "*                  *",0
           ;.byte "^^^^^^^^^^^^^^^^^^^",0

                         ; C,  C_S, D, D_S, E, F, F_S,  G,   G_S,  A,  A_S,  B,
NOTE_TABLE_C3_R00: .byte 68, 21, 232, 191, 151, 114, 79, 46, 14, 241, 213, 186    ;octave 3
NOTE_TABLE_C4_R00: .byte 162, 138, 116, 95, 75, 57, 39, 23, 7, 248, 234, 221     ;octave 4
NOTE_TABLE_C5_R00: .byte 209, 197, 186, 175, 165, 156, 147, 139, 131, 124, 117, 110  ;octave 5
NOTE_TABLE_C3_R01: .byte 3, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1
NOTE_TABLE_C4_R01: .byte   1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0      
NOTE_TABLE_C5_R01: .byte   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
KEY_PAD_CHAR: .byte 'A','W','S','E','D','F','T','G','Y','H','U','J','C','4'
KEY_PAD_CHAR_LOW: .byte 'a','w','s','e','d','f','t','g','y','h','u','j','c','4'
KEY_PAD_PIXEL: .byte $64,$51,$66,$53,$68,$69,$56,$6B,$58,$6D,$5A,$6F,$B8,$B9

MSG_ZUTA:      .byte "** Zebra   Piano **",0
                     ;123456789ABCDEFGHIJK123456789ABCDEFGHIJK 

KEY_IS_PRESSED     = $2F
VOL = $2E
IS_WEAK = $2D
IS_WEAK_2 = $2C
NOTE_VECTOR_R0 = $10
NOTE_VECTOR_R1 = $12

ZUTA:       LDA #$FF               ;clear screen
            STA $8020
            LDA #<MSG_ZUTA         ;show welcome screen
            STA MSGL
            LDA #>MSG_ZUTA
            STA MSGH
            JSR SHWMSG

            LDA #$FF               ;set button states
            STA IS_WEAK
            LDA #$00
            STA VOL
            LDA #$07
            STA IS_WEAK_2

            LDA #<NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1+1           
            

            LDX #$00
PRINT_KEY:  LDY KEY_PAD_PIXEL,X
            LDA KEY_PAD_CHAR,X
            STA $7300,Y
            INX
            TXA
            CMP #$0E
            BNE PRINT_KEY

            LDA #$0D
            STA $7319

            LDX #$00


NEXT_CHAR:  
            LDA $8001
            CMP #$00
            BEQ N_1
            CMP #$33 ; octave 3
            BEQ SET_OCTAVE_C3
            CMP #$34 ; octave 4
            BEQ SET_OCTAVE_C4
            CMP #$35 ; octave 5
            BEQ SET_OCTAVE_C5

            JMP KEY_PRESSED

SET_OCTAVE_C3:
           
             
            LDA #<NOTE_TABLE_C3_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C3_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C3_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C3_R01
            STA NOTE_VECTOR_R1+1  
            LDA #$33
            STA $73B9
            JMP NEXT_CHAR
SET_OCTAVE_C4:
              LDA #<NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C4_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C4_R01
            STA NOTE_VECTOR_R1+1  
            LDA #$34
            STA $73B9
              JMP NEXT_CHAR

SET_OCTAVE_C5:
            LDA #<NOTE_TABLE_C5_R00
            STA NOTE_VECTOR_R0
            LDA #>NOTE_TABLE_C5_R00
            STA NOTE_VECTOR_R0+1 

            LDA #<NOTE_TABLE_C5_R01
            STA NOTE_VECTOR_R1
            LDA #>NOTE_TABLE_C5_R01
            STA NOTE_VECTOR_R1+1  
            LDA #$35
            STA $73B9
              JMP NEXT_CHAR
           
 N_1:       CMP IS_WEAK      ;A=0
            BEQ SET_AY_VOL_DOWN
            DEC IS_WEAK      
            JMP NEXT_CHAR

SET_AY_VOL_DOWN:  

            CMP IS_WEAK_2
            BEQ N_3
            DEC IS_WEAK_2
            LDA #$FF
            STA IS_WEAK
            JMP NEXT_CHAR
 N_3:       LDA VOL
            CMP #$00
            BEQ NEXT_CHAR
            DEC VOL
            LDA VOL
            STA $A008
            JMP NEXT_CHAR
              
 SETAY:     
              LDA #$00
            STA $A008
 
 
              LDA #$0F
            STA VOL
            LDA #$FF
            STA IS_WEAK
            LDA #$07
            STA IS_WEAK_2

            TXA
            TAY

            LDA (NOTE_VECTOR_R0),Y
            STA $A000
            LDA (NOTE_VECTOR_R1),Y
            STA $A001
            
            LDA #$3E
            STA $A007
            LDA VOL
            STA $A008
            JMP NEXT_CHAR


KEY_PRESSED: 
             LDX #$00
             

PRESSED_1:   CMP KEY_PAD_CHAR_LOW,X
             BEQ SETAY    ; X - the pressed key in C3-C5
             INX
             PHA
             TXA
             CMP #$0C
             BEQ NEXT_KEY
             PLA
             JMP PRESSED_1
NEXT_KEY:    

              JMP NEXT_CHAR



