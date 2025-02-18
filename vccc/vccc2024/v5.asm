; Vintage Computing Christmas Challenge 2024
; Jose Moreno Prieto 'Xeleh' - 10/12/2024

            org     100h
main        mov     di,string+4     ; di = pointer to present string (+4 = after the lace)
            mov     dx,18           ; dx = current row = 18
.l1         mov     ax,0d0ah        ; ax = crlf
            stosw                   ; add crlf to string
            mov     bx,'+-'         ; chars for horizontal line: bl = "+", bh = "-"
            mov     al,dl           ; al = current row
            aam     9               ; horizontal line?
            jz      .go             ; yes -> use current chars
            mov     bx,'| '         ; no -> use chars for vertical line: bl = "|", bh = " "
.go         xchg    ax,bx           ; al = bl, ah = bh (optimized)
.l2         stosw                   ; add chars to the string
            xchg    al,ah           ; exchange chars so al = fill char
            mov     cl,7            ; 
            rep     stosb           ; add fill char 7 times
            xchg    al,ah           ; exchange chars so al = line char
            cmc                     ; 
            jc      .l2             ; one more time
            stosb                   ; add closing line char to string
            dec     dx              ; previous row
            jns     .l1             ; loop until row is -1
            mov     byte[di],'$'    ; add msdos end char to the string
            xchg    bp,ax           ; ah = 09h (print string - msdos function)
            mov     dx,string       ; dx = present string
            int     21h             ; print string

%ifdef      debug
            waitkey
            ret
%endif

string      db      9,'\o/'         ; lace
