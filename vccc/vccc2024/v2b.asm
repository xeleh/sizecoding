; Vintage Computing Christmas Challenge 2024
; Jose Moreno Prieto 'Xeleh' - 06/12/2024

            org     100h
main        push    0b801h          ; b800h (VGA text) + 16 bytes (8 chars + 8 attributes)
            pop     es
            xor     di,di
;draw lace
            mov     si,lace         ; lace chars
.l1         movsb                   ; copy to screen memory
            inc     di              ; next char
            jpo     .l1             ; repeat 2 more times
;draw box
            mov     di,3*2+8*2      ; set pointer to last column
            mov     cl,18           ; cl = row = 18
.row        mov     dx,18           ; dl = column = 18
            add     di,160-19*2     ; set pointer to next line
.check1     mov     bx,'+-'         ; default char = "-", alt char = "+"
            mov     al,cl           ; check if current row corresponds to horizontal line
            aam     9               ;
            jz      .check2         ; yes -> do a second check for intersection
            mov     bx,'! '         ; default char = "-", alt char = " "
.check2     mov     al,dl           ; check if current column corresponds to a vertical line
            aam     9               ;
            jz      .print          ; yes -> print the default char
            mov     bl,bh           ; no -> use alt char
.print      xchg    ax,bx           ; set char to print
            stosb                   ; print char
            inc     di              ; next column
            dec     dx              ; previous column
            jns     .check1         ; no -> loop
            dec     cx
            jns     .row

%ifdef      debug
            waitkey
            ret
%endif

lace       db      "\O/"