;----[ unpackdnp.a ]--------------------

         .include "//os/s/:basic.s"
         .include "//os/s/:math.s"

         .include "//os/s/ker/:file.s"
         .include "//os/s/ker/:io.s"
         .include "//os/s/ker/:iec.s"

buffer   = $c000
ptr      = $fb ;$fc

         lda #$12 ;Reverse On
         jsr chrout

         ;Open Command Channel
         lda #15 ;Logical File #
         ldx $bf ;JiffyDOS Dest Dev
         ldy #15 ;Channel
         jsr setlfs

         lda #0
         jsr setnam
         jsr open

         ;Open Output Buffer
         lda #2  ;Logical File #
         ldx $bf ;JiffyDOS Current Dev
         ldy #2  ;Channel
         jsr setlfs

         lda #1  ;Command Length
         ldx #<daccess
         ldy #>daccess
         jsr setnam
         jsr open

         ;Open Src Image File
         lda #3  ;Logical File #
         ldx $be ;JiffyDOS Source Dev
         ldy #3  ;Channel
         jsr setlfs

         lda #15 ;Filename Length
         ldx #<imgfile
         ldy #>imgfile
         jsr setnam
         jsr open


         ;Initialize Variables
         jsr zerotrk
         jsr zerosec

         lda #0
         sta ctrack

trkloop  inc ctrack
         beq done
         jsr inctrk

         lda #0
         sta csector
         jsr zerosec
         jmp secloop+3

secloop  jsr incsec

         jsr copyblock
         jsr setblock

         inc csector
         bne secloop
         beq trkloop

         ;Done... close up.
done     lda #3
         jsr close
         lda #2
         jsr close
         lda #15
         jsr close

         jsr clall

         lda #$92 ;Reverse off
         jmp chrout


copyblock
         ;Read Block
         ldx #3
         jsr chkin

         ldy #0
         jsr acptr
         sta buffer,y
         iny
         bne *-7

         jsr clrchn

         ;Reset Buffer Pointer
         ldx #15
         jsr chkout

         ldy #0
         lda setbptr,y
         beq *+8
         jsr chrout
         iny
         bne *-9

         jsr clrchn

         ;Write Block
         ldx #2
         jsr chkout

         ldy #0
         lda buffer,y
         jsr ciout
         iny
         bne *-7

         jmp clrchn

setblock ;Y <- 1st digit of err code.
         ;Set Block
         ldx #15
         jsr chkout

         ldy #0
         lda blokcmd,y
         beq *+8
         jsr chrout
         iny
         bne *-9

         jsr clrchn

         ldx #15
         jsr chkin
         jsr chrin
         tay

         jmp clrchn

zerotrk  ;Set Track to 000
         lda #"0"
         sta track
         sta track+1
         sta track+2
         rts

inctrk   ;Increment Track
         lda #" " ;space
         jsr chrout

         ;Roll Track 1's Place
         ldx track+2
         inx
         cpx #":"
         bcs *+6

         stx track+2
         rts

         ldx #"0"
         stx track+2

         ;Roll Track 10's Place
         ldx track+1
         inx
         cpx #":"
         bcs *+6

         stx track+1
         rts

         ldx #"0"
         stx track+1

         ;Roll Track 100's Place
         ldx track
         inx
         cpx #":"
         bcs *+6

         stx track
         rts

         ldx #"0"
         stx track

         rts

zerosec  ;Set Sector to 000
         lda #"0"
         sta sector
         sta sector+1
         sta sector+2
         rts

incsec   ;Increment Sector

         ;Roll Sector 1's Place
         ldx sector+2
         inx
         cpx #":"
         bcs *+6

         stx sector+2
         rts

         ldx #"0"
         stx sector+2

         ;Roll Sector 10's Place
         ldx sector+1
         inx
         cpx #":"
         bcs *+6

         stx sector+1
         rts

         ldx #"0"
         stx sector+1

         ;Roll Sector 100's Place
         ldx sector
         inx
         cpx #":"
         bcs *+6

         stx sector
         rts

         ldx #"0"
         stx sector

         rts


ctrack   .byte 1
csector  .byte 0

daccess  .text "#"
imgfile  .text "@:image.dnp,r,p"

setbptr  .null "b-p 2 0"

blokcmd  .text "u2 2 0 "
track    .text "000"
         .byte " "
sector   .null "000"
