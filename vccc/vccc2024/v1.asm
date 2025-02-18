; Vintage Computing Christmas Challenge 2024
; Jose Moreno Prieto 'Xeleh' - 06/12/2024

            org     100h
main:
; draw lace
            int     10h             ; 40x25 text mode
            mov     ah,9            ; ah = 09h (print string - msdos function)
            mov     dx,lace         ; dx = lace string
            int     21h             ; print lace
; draw box
            mov     dx,0100h        ; row = 1, col = 0
.check1     mov     cx,'+-'         ; ch = "+", cl = "-"
            mov     al,dh           ; check if current row corresponds to horizontal line
            dec     ax              ; compensate extra line for the lace
            aam     9               ; 
            jz      .check2         ; yes -> do a second check for intersection
            mov     cx,'! '         ; ch = "!", cl = " "
.check2     mov     al,dl           ; check if current column corresponds to a vertical line
            aam     9               ; 
            jz      .print          ; yes -> print the default char
            mov     cl,ch           ; no -> use alt char
.print      mov     ah,02h          ; ah = 02h (set cursor position - bios function)
            int     10h             ; set cursor position
            mov     al,cl           ; set char to print
            int     29h             ; print char
            inc     dx              ; next column
            cmp     dl,19           ; end column?
            jnz     .check1         ; no -> loop
            mov     dl,0            ; carriage return
            inc     dh              ; next row
            cmp     dh,19+1         ; end column?
            jnz     .check1         ; no -> loop

%ifdef      debug
            waitkey
            ret
%endif

lace        db      9,"\O/",13,10,"$"