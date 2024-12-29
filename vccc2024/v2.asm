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
            jpo     .l1             ; repeat 3 times
;draw box
            add     di,160-11*2     ; set pointer to left top corner of the box
            mov     cl,19           ; cl = row = 19
.row        mov     dl,19           ; dl = col = 19
.check1     mov     bx,'+-'         ; default char = "-", alt char = "+"
            mov     al,cl           ; check if current row corresponds to horizontal line
            dec     ax
            aam     9               ;
            jz      .check2         ; yes -> do a second check for intersection
            mov     bx,'! '         ; default char = "-", alt char = " "
.check2     dec     dx              ; previous column
            mov     al,dl           ; check if current column corresponds to a vertical line
            aam     9               ;
            jz      .print          ; yes -> print the default char
            mov     bl,bh           ; no -> use alt char
.print      mov     al,bl           ; set char to print
            stosb                   ; print char
            inc     di              ; next column
            test    dl,dl           ; cursor reached first column?
            jnz     .check1         ; no -> loop
            add     di,160-19*2     ; next line
            loop    .row

%ifdef      debug
            waitkey
            ret
%endif

lace       db      "\O/"