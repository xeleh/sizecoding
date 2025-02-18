; Vintage Computing Christmas Challenge 2023
; Jose Moreno Prieto 'Xeleh' - 19/12/2023

main        cwd                     ; clean dx (dh = cursor row, dl = cursor column)
            mov     cl,19           ; number of rows
.row        mov     dl,19           ; cursor to the end of the line
.col        dec     dx              ; move cursor backwards
            mov     al,3            ; calc determinant for 45 degree lines
            add     al,dl           ; add current cursor column
            add     al,dh           ; add current cursor row
            aam     6               ; determinant is divisible by 6?
            jz      .star           ; yes -> print star
            mov     al,21           ; calc determinant for 135 degree lines
            add     al,dl           ; add current cursor column
            sub     al,dh           ; substract current cursor row
            aam     6               ; determinant is divisible by 6?
            jnz     .next           ; no -> don't print star
.star       mov     ax,02h<<8|'*'   ; ah = 02h (bios function) | al = '*' char
            int     10h             ; set cursor position
            int     29h             ; print star
.next       test    dl,dl           ; cursor reached first column?
            jnz     .col            ; no -> loop
            inc     dh              ; next row
            loop    .row            ; end row? no -> loop

%ifdef      debug
            waitkey
            ret
%endif
