; Vintage Computing Christmas Challenge 2024
; Jose Moreno Prieto 'Xeleh' - 07/12/2024

            org     100h
main        mov     di,string+4     ; di = present string
            mov     cl,19           ; cl = row = 19
.row        mov     dl,19           ; dl = col = 19
            mov     ax,0d0ah        ; ax = crlf
            stosw                   ; add crlf to string
.check1     mov     bx,'+-'         ; bl = "+", bh = "-"
            mov     al,cl           ; al = current row
            dec     ax              ; minus one
            aam     9               ; horizontal line?
            jz      .check2         ; yes -> do a second check for intersection
            mov     bx,'! '         ; bl = "!", bh = " "
.check2     dec     dx              ; previous column
            mov     al,dl           ; al = current column
            aam     9               ; vertical line?
            jz      .print          ; yes -> print char in bl
            mov     bl,bh           ; no -> print char in bh
.print      xchg    ax,bx           ; al = bl (optimized)
            stosb                   ; add char in bl to string
            test    dl,dl           ; end column?
            jnz     .check1         ; no -> loop
            loop    .row            ; previous row, end row? no -> loop
            mov     al,'$'          ; al = '$' end char for msdos print string
            stosb                   ; add end char
            xchg    bp,ax           ; ah = 09h (print string - msdos function)
            mov     dx,string       ; dx = present string
            int     21h             ; print string

%ifdef      debug
            waitkey
            ret
%endif

string      db      9,"\O/"         ; lace