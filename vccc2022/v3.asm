%line       1 "v3.asm"

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
            sub     bx,4
            mov     cl,8
            mov     dx,-4
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
.loop1      pushf
            push    cx
            mov     ah,byte[data+bx]
            inc     bx
            mov     al,' '
            mov     cl,ah
            shr     cl,4
            call    repeatchar
            mov     al,'*'
            mov     cl,ah
            and     cl,0fh
            call    repeatchar
            pop     cx
            popf
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
; cl : number of repetitions
repeatchar:
            jz      .end
.loop1      call    printchar
            loop    .loop1
.end        ret

; al : char to print to console
printchar:
            push    ax
            mov     ah,0eh
            int     10h
            pop     ax
            ret

; for each byte:
; - 4 upper bits -> number of ' '
; - 4 lower bits -> number of '*'
data:
            db      41h,71h         ;     *       *     
            db      42h,52h         ;     **     **     
            db      43h,33h         ;     ***   ***     
            db      44h,14h         ;     **** ****     
            db      0fh,02h         ; ***************** 
            db      1fh,00h         ;  ***************  
            db      2dh,00h         ;   *************   
            db      3bh,00h         ;    ***********    
            db      49h,00h         ;     *********     
