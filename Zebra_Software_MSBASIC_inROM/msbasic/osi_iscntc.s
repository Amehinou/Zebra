.segment "CODE"
ISCNTC:
        lda     $8001           ; keyboard status
        CMP     #$00
        BNE     L0ECC           ; branch if key pressed
        rts                     ; return
L0ECC:
        ;lda     $D010           ; get key data
        cmp     #$1B            ; is it Ctrl-C ?
;!!! *used*to* run into "STOP"
