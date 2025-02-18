; Vintage Computing Christmas Challenge 2023
; Jose Moreno Prieto 'Xeleh' - 04/12/2023

main        int     10h             ; 40x25 text mode
            xor     dx,dx           ; clear dx (dh = cursor row, dl = cursor column)
            mov     bl,6            ; save for later divisions
.l1       	xor     ah,ah           ; calc determinant for 45 degree lines
            mov     al,dl           ; add current cursor column
            add     al,dh           ; add current cursor row
            add     al,3            ; normalize determinant
            div     bl              ; divide by 6
            cmp     ah,0            ; determinant is divisible by 6?            
            jz      .char           ; yes -> print char
            xor     ah,ah           ; calc determinant for 135 degree lines
            mov     al,dl           ; add current cursor column
            sub     al,dh           ; add current cursor row
            add     al,21           ; normalize determinant
            div     bl              ; divide by 6
            cmp     ah,0            ; determinant is divisible by 6?
            jz      .char           ; yes -> print char
            jmp     .next           ; no -> skip char
.char       mov     ax,02h<<8|'*'   ; ah = 02h (bios function) | al = '*' char
            int     10h             ; set cursor position
            int     29h             ; print star
.next       inc     dx              ; next column
            cmp     dl,19           ; end column?
            jnz     .l1             ; no -> loop
            xor     dl,dl           ; carriage return
            inc     dh              ; next row
            cmp     dh,19           ; end row?
            jnz     .l1             ; no -> loop

%ifdef      debug
            waitkey
            ret
%endif
