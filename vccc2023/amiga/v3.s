            code

            moveq   #32,d0              ; set bcpl global area to a minimum safe size
            movea.l ($e0,a2),a4         ; $e0 = wrch(d1), bcpl function to write a char to console
            moveq   #0,d2
            moveq   #0,d3
            moveq   #19,d4
loop:
            moveq   #' ',d1
            moveq   #3,d5
            add     d2,d5
            add     d3,d5
            bsr     test
            moveq   #21,d5
            add     d2,d5
            sub     d3,d5
            bsr     test
            bsr     write
            addq    #1,d2
            cmp     d4,d2
            bne     loop
            moveq   #10,d1
            bsr     write
            moveq   #0,d2
            addq    #1,d3
            cmp     d4,d3
            bne     loop

; proper exit to AmigaDOS (commented as it is not required for this challenge)
            ; moveq   #0,d0
            ; rts

; check whether the determinant in d5 indicates a printable position
test        divu.w  #6,d5
            swap    d5
            cmp     #0,d5
            bne     .end
            moveq   #'*',d1
.end        rts

; write the char in d1 to console
write       movem.l d0-d4/a1-a6,-(sp)
            jsr     (a5)
            movem.l (sp)+,d0-d4/a1-a6
            rts
