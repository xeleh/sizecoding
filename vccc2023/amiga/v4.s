; Vintage Computing Christmas Challenge 2023
; Jose Moreno Prieto 'Xeleh' - 19/12/2023
; Greetz to Crumb (thanks for the hint!) and the #amicoders group

            code

main        moveq   #8,d0               ; set bcpl global area to a minimum safe size
            movea.l ($e0,a2),a4         ; $e0 = wrch(d1), bcpl function to write a char to console
            moveq   #19-1,d2            ; init current row value
.row        moveq   #19-1,d3            ; init current column value
.col        moveq   #' ',d1             ; set next char to write to a space by default
            moveq   #3,d4               ; calc determinant for 45 degree lines
            add     d3,d4               ; add current column
            add     d2,d4               ; add current row
            bsr.b   test                ; test determinant
            moveq   #21,d4              ; calc determinant for 135 degree lines
            add     d3,d4               ; add current column
            sub     d2,d4               ; substract current row
            bsr.b   test                ; test determinant
            bsr.b   write               ; write the char
            dbra    d3,.col             ; decrement column value and loop
            moveq   #10,d1              ; set char to write to ASCII LF (line feed)
            bsr.b   write               ; write the char
            dbra    d2,.row             ; decrement row value and loop

; proper exit to AmigaDOS (commented as it is not required for this challenge)
            ; moveq   #0,d0
            ; rts

; check whether the determinant in d4 indicates a printable position
test        divu.w  #6,d4               ; divide by 6
            swap    d4                  ; swap to have the remainder in the low word
            tst     d4                  ; is the remainder 0?
            bne.b   .end                ; no -> not divisible, just end the subroutine
            moveq   #'*',d1             ; yes -> set next char to write to '*'
.end        rts                         ; return (also to be used as final rts after main loop ends)

; write the char in d1 to console
write       movem.l d0-d3/a1-a6,-(sp)   ; preserve bcpl environment
            jsr     (a5)                ; call bcpl function in a4
            movem.l (sp)+,d0-d3/a1-a6   ; restore bcpl environment
            rts                         ; return





