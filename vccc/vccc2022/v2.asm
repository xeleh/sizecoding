%line       1 "v2.asm"

; Vintage Computing Christmas Challenge 2022
; Jose Moreno Prieto - Xeleh
; 08/12/2022

            org     100h
            section .text

; upper half
            mov     cl,9
            xor     dx,dx
            call    printlines

; lower half (mirrored)
            sub     bx,8
            mov     cl,8
            mov     dx,-8
            call    printlines

; wait for a key press and finish
%ifdef      debug
            waitkey
%endif
            ret

; bx : data pointer offset
; cx : number of lines to print
; dx : data pointer increment
printlines: 
.loop1:
            mov     al,' '
            call    repeat
            mov     al,'*'
            call    repeat
            cmc
            jc      .loop1
            mov     al,13
            call    printchar
            mov     al,10
            call    printchar
            add     bx,dx
            clc
            loop    .loop1
            ret

; al : char to print to console
repeat:
            pushf
            push    cx
            mov     cl,byte[data+bx]
            inc     bx
            cmp     cl,0
            jz      .end
.loop1      call    printchar
            loop    .loop1
.end        pop     cx
            popf
            ret

; al : char to print to console
printchar:
            push    ax
            mov     ah,0eh
            int     10h
            pop     ax
            ret

data        db      4,1,7,1
            db      4,2,5,2
            db      4,3,3,3
            db      4,4,1,4
            db      0,17,0,0
            db      1,15,0,0
            db      2,13,0,0
            db      3,11,0,0
            db      4,9,0,0
