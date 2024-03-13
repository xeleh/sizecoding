; Vintage Computing Christmas Challenge 2023
; Jose Moreno Prieto 'Xeleh' - 05/12/2023

main        cwd                     ; clear dx (dh = cursor row, dl = cursor column)
            mov     cl,19           ; number of rows
.l1         mov     ax,3            ; calc determinant for 45 degree lines
            add     al,dh           ; add current cursor row
            call    char            ; draw char on determinant
            mov     ax,21           ; calc determinant for 135 degree lines
            sub     al,dh           ; substract current cursor row
            call    char            ; draw char on determinant
            inc     dx              ; next column
            cmp     dl,19           ; end column?
            jnz     .l1
            xor     dl,dl           ; carriage return
            inc     dh              ; next row
            loop    .l1              ; end row?

%ifdef      debug
            waitkey
%endif

; finish determinant calculation by adding the current cursor column
; if the determinant in ax is divisible by 6:
; move the cursor to dh,dl and print a '*' char
char        add     al,dl
            aam     6
            jnz     .end
            mov     ax,02h<<8|'*'
            int     10h
            int     29h
.end        ret
