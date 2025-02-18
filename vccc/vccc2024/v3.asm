; Vintage Computing Christmas Challenge 2024
; Jose Moreno Prieto 'Xeleh' - 06/12/2024

            org     100h
main:
; draw box
            mov     dh,19           ; row = 19
.row        mov     dl,19           ; col = 19
.check1     mov     cx,'+-'         ; default char = "-", alt char = "+"
            mov     al,dh           ; check if current row corresponds to horizontal line
            dec     ax              ; compensate extra line for the lace
            aam     9               ;
            jz      .check2         ; yes -> do a second check for intersection
            mov     cx,'! '         ; default char = "-", alt char = " "
.check2     dec     dx              ; previous column
            mov     al,dl           ; check if current column corresponds to a vertical line
            aam     9               ;
            jz      .print          ; yes -> print the default char
            mov     cl,ch           ; no -> use alt char
.print      mov     ah,02h          ; ah = 02h (set cursor position - bios function)
            int     10h             ; set cursor position
            mov     al,cl           ; set char to print
            int     29h             ; print char
            test    dl,dl           ; cursor reached first column?
            jnz     .check1         ; no -> loop
            dec     dh              ; previous row
            jnz     .row            ; cursor reached first row? no -> loop
; draw lace
            int     10h             ; set cursor position
            xchg    bp,ax           ; ah = 09h (print string - msdos function)
            mov     dx,lace         ; dx = lace string
            int     21h             ; print lace

%ifdef      debug
            waitkey
            ret
%endif

lace        db      9,"\O/$"