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





           .org $ED80
              

RESET:      CLD             ; Clear decimal arithmetic mode.
            CLI

           
           
            LDA #$FF        ; clear screen
            STA $8020

           
           
            LDA #<MSG1
            STA MSGL
            LDA #>MSG1
            STA MSGH
            JSR SHWMSG      ;* Show Welcome.
            ;LDA #$0A
            ;JSR ECHO        ;* New line.
SOFTRESET:  LDA #$9B        ;* Auto escape.
NOTCR:      CMP #$88        ;* "<-"? Note this was changed to $88 which is the back space key.
            BEQ BACKSPACE   ; Yes.
            CMP #$9B        ; ESC?
            BEQ ESCAPE      ; Yes.
            INY             ; Advance text index.
            BPL NEXTCHAR    ; Auto ESC if >127.
ESCAPE:     LDA #$52        ; "R"
            JSR ECHO        ; Output it.
            LDA #$65        ; "e"
            JSR ECHO        ; Output it.
            LDA #$61        ; "a"
            JSR ECHO        ; Output it.
            LDA #$64        ; "d"
            JSR ECHO        ; Output it.
            LDA #$79        ; "y"
            JSR ECHO        ; Output it.
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


