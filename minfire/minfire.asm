; minfire
; a good looking fire effect in 64 bytes!
; coded by xeleh
; 17/01/2022

            org     100h
            section .text

; constants
width       equ     320                 ; screen width
timer       equ     46ch                ; bios timer

; set screen mode and palette
            mov     al,13h              ; bios service: set screen mode
            les     bp,[bx]             ; set pointer to vga memory
            pop     ds                  ; make sure that we can read the bios timer
            inc     cx                  ; mov cx,0 in 1 byte (assuming cx = 0xff)
            cwd                         ; mov dx,0 in 1 byte
color       int     10h                 ; call bios service
            mov     ax,1010h            ; bios service: set one DAC color register
            test    bl,32               ; colors 32-63?
            jz      .red                ; no -> red gradient, yes -> orange gradient
.green      inc     ch                  ; increment green component
            jmp     .next               ; hold the red component
.red        inc     dh                  ; increment red component
.next       inc     bx                  ; next color
            jnz     color               ; repeat

; draw fire
fire        mov     ax,[es:di+width-1]  ; get the values of two pixels above
            add     al,ah               ; sum their color indexes
            add     al,ah               ; stoke the fire
            xor     al,ah               ; add noise
            add     al,[es:di]          ; add the current pixel
            xor     al,[es:di]          ; more noise
            shr     al,2                ; calculate the average color index
            stosb                       ; draw pixel
            cmp     di,-width           ; bottom reached?
            jnz     fire                ; no -> next pixel

; draw some shit at the bottom
            mov     cl,width/2          ; a whole line
.shit       add     ax,[timer]          ; randomize
            stosw                       ; draw
            loop    .shit               ; next 2 pixels

            jmp     fire
