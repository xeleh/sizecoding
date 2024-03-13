            code

            moveq   #32,d0              ; set bcpl global area to a minimum safe size
            moveq   #0,d2
            moveq   #0,d3
col         moveq   #'*',d1
test1       move.l  #3,d4
            add.w   d2,d4
            add.w   d3,d4
            divu.w  #6,d4
            swap    d4
            cmp.w   #0,d4
            beq     skip
test2       move.l  #21,d4
            add.w   d2,d4
            sub.w   d3,d4
            divu.w  #6,d4
            swap    d4
            cmp.w   #0,d4
            beq     skip
            moveq   #' ',d1
skip        movea.l ($e0,a2),a4         ; $e0 = wrch(d1), bcpl function to write a char to console
            bsr     write
            addq    #1,d2
            cmp     #19,d2
            bne     col
            moveq   #10,d1
            bsr     write
            moveq   #0,d2
            addq    #1,d3
            cmp     #19,d3
            bne     col

; proper exit to AmigaDOS (commented as it is not required for this challenge)
            ; moveq   #0,d0
            ; rts

; write a char (d1) to console
write       movem.l d0-d4/a1-a6,-(sp)
            jsr     (a5)
            movem.l (sp)+,d0-d4/a1-a6
            rts
