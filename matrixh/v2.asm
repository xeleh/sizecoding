; Matrix digital rain in 128 bytes
; Jose Moreno Prieto - Xeleh
; 07/02/2025

            org     100h

; features
vsync       equ     1                   ; 1 -> sync with system timer (+8 bytes)
escape      equ     1                   ; 1 -> to quit with escape (+5 bytes)

; constants
cols        equ     40
rows        equ     25
headcolor   equ     62

init        mov     al,13h              ; 13h = 320x200 256 colors graphics mode
            int     10h                 ; set video mode

; init column data
            mov     di,data             ; di = column data
            mov     ax,(rows-1)<<8|0    ; ah (head row) = rows - 1, al (delay) = 0
            mov     ch,05h              ; cx = 0500h = 1280 (closest number to cols*(1+rows))
            rep     stosw               ; write words
; init palette
            xchg    ax,bx               ; clear bl
            xchg    ax,dx               ; clear dl
.color      mov     ax,1010h            ; bios service: set one DAC color register
            int     10h                 ; change color
            inc     ch                  ; increment green component
            inc     bx                  ; next color
            jnz     .color              ; repeat
            mov     bl,headcolor        ; set head color to white
            dec     cx                  ; ch (green) = ffh, cl (blue) = ffh
            dec     dx                  ; dh (red) = ffh
            int     10h                 ; change color

effect      mov     si,data             ; si = column data

            mov     cl,cols-1           ; prepare columns loop
.col        lodsw                       ; al = delay, ah = head row
            cmp     al,0                ; is delay zero?
            je      .l1                 ; yes -> continue
            dec     ax                  ; no -> decrease delay
            jmp     .l2                 ; skip update code
.l1         inc     ah                  ; increase current row
            cmp     ah,rows             ; column complete?
            jne     .l2                 ; no -> continue
            rdtsc                       ; al = pseudo-random delay value
            shl     al,2                ; randomize it a litte bit
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
            or      al,36               ; filter annoying chars
            mov     ah,headcolor        ; set head color
.l3         mov     bl,ah               ; bl = color
            mov     ah,0eh              ; print char function
            int     10h                 ; print it
            mov     ah,bl               ; ah = color
            cmp     ah,2                ; color == 2?
            je      .l4                 ; yes -> skip fade
            sub     ah,2                ; fade char color
.l4         mov     [si-2],ax           ; update data
            dec     dh                  ; prev row
            jns     .row                ; loop if row >= 0

            dec     cl                  ; prev col
            jns     .col                ; loop if col >= 0
            hlt                         ; cheap delay

%if         vsync
            mov     dx,3dah             ; vga input status #1 register
.waitvbl    in      al,dx               ; get status
            test    al,8                ; check vretrace bit
            jz      .waitvbl            ; wait until end of vertical retrace
%endif
%if         escape
            in      al,60h              ; check keyboard data port
            dec     al                  ; because escape key scancode is 1
            jnz     effect              ; escape key? no -> next frame
            ret                         ; exit program
%else
            jmp     effect              ; next frame
%endif

data:       ; a sequence of <cols> buffers of length <1+rows> words each
            ; words in each buffer: [headrow:delay], [color:char], [color:char], ...
