            code

execbase    equ     4
openlib     equ     -552
output      equ     -60
write       equ     -48
closelib    equ     -414

            movea.l execbase.w,a6
            lea     dosname(pc),a1      ; a1 = library name
            moveq   #0,d0               ; any version
            jsr     openlib(a6)         ; open dos.library
            move.l  d0,a1               ; a1 = dos base
            jsr     output(a1)          ; get console handle
            move.l  d0,d1               ; d1 = console handle
            moveq   #1,d3               ; write only one char at a time

            moveq   #0,d4
            moveq   #0,d5
col         lea     star(pc),a2
test1       moveq   #3,d6
            add.w   d4,d6
            add.w   d5,d6
            divu.w  #6,d6
            swap    d6
            tst     d6
            beq.s   skip
test2       moveq   #21,d6
            add.w   d4,d6
            sub.w   d5,d6
            divu.w  #6,d6
            swap    d6
            tst     d6
            beq.s   skip
            lea     space(pc),a2
skip        bsr.s   putchar
            addq    #1,d4
            cmp     #19,d4
            bne.s   col
            lea     lf(pc),a2
            bsr.s   putchar
            moveq   #0,d4
            addq    #1,d5
            cmp     #19,d5
            bne.s   col

; proper exit to AmigaDOS (commented as it is not required for this challenge)
            ; jsr     closelib(a6)
            ; moveq   #0,d0
            ; rts

; write the char pointed by a2 to console
putchar     movem.l d0-d5/a1-a6,-(sp)
            move.l  a2,d2
            jsr     write(a1)
            movem.l (sp)+,d0-d5/a1-a6
            rts

dosname     dc.b    "dos.library",0
star        dc.b    "*"
space       dc.b    " "
lf          dc.b    10