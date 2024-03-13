; Vintage Computing Christmas Challenge 2023
; Jose Moreno Prieto 'Xeleh' - 04/12/2023

main        int     10h             ; 40x25 text mode
            cwd                     ; clear dx (dh = cursor row, dl = cursor column)
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
            cmp     dh,19           ; end row?
            jnz     .l1

%ifdef      debug
            waitkey
%endif

; finish determinant calculation by adding the current cursor column
; if the determinant in ax is divisible by 6:
; move the cursor to dh,dl and print a '*' char
char        add     al,dl
            mov     bl,6
            div     bl
            test    ah,ah
            jnz     .end
            mov     ax,02h<<8|'*'
            int     10h
            int     29h
.end        ret
