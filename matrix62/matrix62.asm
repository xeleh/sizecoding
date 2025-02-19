; Matrix digital rain in 62 bytes
; Jose Moreno Prieto - Xeleh
; 19/02/2025

            org     100h

cols        equ     80
rows        equ     25

init:
            push    0b800h              ; text video memory segment
            pop     ds                  ; set ds to it 
            std                         ; read from bottom to top

palette:
            inc     cx                  ; clear cx (ch = green, cl = blue)
            cwd                         ; clear dx (dh = red)
.color      mov     ax,1010h            ; bios service: set one dac color register
            int     10h                 ; change color
            add     ch,4                ; increment green component
            inc     bx                  ; next color
            cmp     bl,3fh              ; is head color? (16 is mapped to 3fh)
            jne     .color              ; no -> repeat

effect:
            mov     si,rows*cols*2-2    ; start on bottom right corner
.l2         lodsw                       ; get char (al) and color attrs (ah)
            cmp     ah,16               ; head color?
            jne     .l3                 ; no -> check if char is on wait
            mov     [si+cols*2+2],ax    ; set head one row below
            rdtsc                       ; pseudo random char (al)
            mov     ah,15               ; make color bright green
            jmp     .ok                 ; and write 
.l3         test    ah,ah               ; char on wait (color 0)?
            jnz     .l4                 ; no -> just fade it
            dec     al                  ; decrement char (wait time)
            jnz     .ok                 ; wait over? no -> write
            mov     ah,17               ; yes -> make it column head
.l4         dec     ah                  ; fade the color
.ok         mov     [si+2],ax           ; write char and color attrs back
            test    si,si               ; top left corner reached?
            jns     .l2                 ; no -> loop
            hlt                         ; cheap delay
            jmp     effect              ; next frame

; notes:
; - text mode 80x25 is assumed
; - replacing 'dec al' with 'dec ax' saves 1 byte but produces artifacts
; - fucking Hellmood! ;)
