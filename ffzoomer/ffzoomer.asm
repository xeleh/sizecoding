; ffzoomer - fake fractal zoomer
; a variation of the chaos/dweezil zoomer in 127 bytes!
; coded by xeleh
; 09/02/2022

            org     100h
            section .text

; constants
screenw     equ     320                 ; screen width
screenh     equ     200                 ; screen height
blockw      equ     16                  ; block width
blockh      equ     11                  ; block height
rows        equ     16                  ; number of rows
cols        equ     20                  ; blocks per row
seedo       equ     105*screenw+149     ; screen offset for seed

; init
            mov     al,13h
            int     10h
            mov     fs,bx               ; we need this to read the timer
            mov     bp,8000h            ; intermediate buffer
            cwd                         ; needed on real hardware

; copy blocks from vga memory
effect      push    0a000h
            pop     ds
            mov     es,bp
            add     bx,screenw*(blockh+1)
            mov     si,bx
            add     si,blockw
            xor     di,di
            mov     cl,rows
.l1         mov     dl,cols
            push    si
.l2         push    cx

; inner loop to copy a block line by line
                    mov     cl,blockh
.l3                 push    cx
                    mov     cl,blockw/2
                    rep     movsw
                    add     si,screenw-blockw
                    add     di,screenw-blockw
                    pop     cx
                    loop    .l3

            pop     cx
            sub     si,screenw*blockh-screenw-blockw+1
            sub     di,screenw*blockh-blockw
            dec     dx
            jnz     .l2
            pop     si
            add     si,screenw*blockh-screenw-1
            add     di,screenw*blockh-cols*blockw
            dec     cx
            jnz     .l1

; copy blocks to vga memory
            push    ds
            pop     es
            mov     ds,bp
            xor     si,si
            mov     di,bx
            mov     cx,rows*blockh*screenw/2
            rep     movsw

; poor man's clipping
            mov     di,screenw*(blockh+1)-blockw*2
            mov     al,0
            mov     dl,screenh-(blockh+1)*2
.l4         mov     cl,blockw*4
            rep     stosb
            add     di,screenw-blockw*4
            dec     dx
            jnz     .l4

; draw some shit 
            mov     di,seedo
            add     ax,[fs:46ch]
            stosw
            add     bx,bx
            xor     ax,bx
            stosw

; update shift
            xchg    bx,ax
            and     bx,1fh

; repeat
            hlt
            jmp     effect
