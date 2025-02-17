; Matrix digital rain in 128 bytes
; Jose Moreno Prieto - Xeleh
; 05/02/2025

            org     100h

cols        equ     40
rows        equ     25

; switch to 320x200 graphics mode
main        mov     ax,13h
            int     10h

; init column data
            mov     di,data             ; di = column data
            mov     ax,(rows-1)<<8|0    ; ah (head row) = rows - 1, al (delay) = 0
            mov     cx,cols*(1+rows)    ; total number of words to initialize
            rep     stosw               ; write words

; palette
            xor     bx,bx               ; clear bx
            xor     dx,dx               ; clear dx
.color      mov     ax,1010h            ; bios service: set one DAC color register
            int     10h                 ; change color
            inc     ch                  ; increment green component
            inc     bx                  ; next color
            jnz     .color              ; repeat
            mov     bl,62               ; set head color (62) to white
            mov     cx,0ffffh           ; ch (green) = ffh, cl (blue) = ffh
            mov     dh,0ffh             ; dh (red) = ffh
            int     10h

; effect
.fx         mov     si,data             ; si = column data
            mov     cl,cols-1           ; prepare columns loop
.col        lodsw                       ; al = delay, ah = head row
            cmp     al,0                ; is delay zero?
            je      .l1                 ; yes -> continue
            dec     al                  ; no -> decrease delay
            jmp     .l2                 ; skip update code
.l1         inc     ah                  ; increase current row
            cmp     ah,rows             ; column complete?
            jne     .l2                 ; no -> continue
            mov     al,cl               ; generate a pseudo-random delay
            shl     al,4                ; randomize it a litte bit
            mov     ah,-1               ; head row = 0
.l2         mov     [si-2],ax           ; update column head data

            mov     ch,ah               ; ch = head row
            mov     dh,rows-1           ; prepare rows loop
.row        mov     ah,02h              ; move cursor function
            mov     dl,cl               ; dl = column
            int     10h                 ; move it (bh needs to be 0 here)

            lodsw                       ; al = char, ah = color
            cmp     ch,dh               ; current row = head row?
            jne     .l3                 ; no -> continue
            push    dx                  ; rdtsc changes dx, so save it
            rdtsc                       ; al = pseudo-random char (thx iolo!)
            pop     dx                  ; restore dx
            and     al,075h             ; filter annoying chars
            mov     ah,62               ; set head color
.l3         mov     bl,ah               ; bl = color
            mov     ah,0eh              ; print char function
            int     10h                 ; print it

            xchg    ah,bl               ; ah = color
            cmp     ah,2                ; color == 2?
            je      .l4                 ; yes -> skip fade
            sub     ah,2                ; fade char color
.l4         mov     [si-2],ax           ; update data

            dec     dh                  ; prev row
            jns     .row                ; loop if row >= 0
            dec     cl                  ; prev col
            jns     .col                ; loop if col >= 0

            hlt                         ; cheap vsync
            in      al,60h              ; check keyboard data port
            dec     al                  ; because escape key scancode is 1
            jnz     .fx                 ; escape key? no -> next frame
            ret                         ; yes -> exit

data:       ; a sequence of <cols> buffers of length <1+rows> words each
            ; words in each buffer: [headrow:delay], [color:char], [color:char], ...
