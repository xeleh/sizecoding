%line       1 "v1.asm"

; Vintage Computing Christmas Challenge 2022
; Jose Moreno Prieto - Xeleh
; 08/12/2022

            org     100h
            section .text

; upper half
            mov     cl,9
            mov     dx,2
            call    printlines

; lower half (mirrored)
            sub     bx,4
            mov     cl,8
            neg     dx
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
            push    dx
.loop1      mov     ah,byte[data+bx]
            call    printbits
            mov     ah,byte[data+bx+1]
            call    printbits
            cmp     cx,5                    ; corners
            jne     .crlf
            stc
            call    printcarry
.crlf       add     bx,dx
            mov     al,13
            call    printchar
            mov     al,10
            call    printchar
            loop    .loop1
            pop     dx
            ret

; ah : byte to print
; bits 1 -> * , bits 0 -> space
printbits:  
            push    dx
            mov     dx,15
.loop1      bt      ax,dx
            call    printcarry
            dec     dx
            cmp     dx,7
            jne     .loop1
            pop     dx
            ret

; carry flag == 1 -> print * , carry flag == 0 -> print space
printcarry:
            jnc     .space
            mov     al,'*'
            jmp     $+4
.space      mov     al,' '
            call    printchar
            ret

; al : char to print to console
printchar:
            push    ax
            mov     ah,0eh
            int     10h
            pop     ax
            ret

data:
            db      00001000b,00001000b
            db      00001100b,00011000b
            db      00001110b,00111000b
            db      00001111b,01111000b
            db      11111111b,11111111b
            db      01111111b,11111111b
            db      00111111b,11111110b
            db      00011111b,11111100b
            db      00001111b,11111000b
