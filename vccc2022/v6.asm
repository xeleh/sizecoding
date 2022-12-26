%line       1 "v6.asm"

; Vintage Computing Christmas Challenge 2022
; Jose Moreno Prieto - Xeleh
; 26/12/2022

            org     100h
            section .text

            int     10h             ; 40x25 text mode
            mov     si,data
            mov     cl,4            ; 4 groups of lines
l1          push    cx
            mov     dx,[si]         ; get initial cursor position
            mov     cl,17           ; initial line length in chars
l2          push    cx
            push    dx
l3          mov     ax,02h<<8|'*'   ; ah = 02h (bios set cursor position) | al = character to print
            int     10h             ; move cursor
            int     29h             ; print character
            add     dx,[si+2]       ; update cursor position
            loop    l3              ; next character
            pop     dx
            add     dx,[si+4]       ; update cursor position
            pop     cx
            sub     cl,2            ; make next line shorter by 2 chars
            cmp     cl,7            ; check if this was the last line of the group
            jne     l2              ; next line
            add     si,6
            pop     cx
            loop    l1              ; next group

%ifdef      debug
            waitkey
%endif
            ret

; each tupla of 3 words defines how to paint a group of 5 lines
; 1st word: initial cursor position (h: row | l:col)
; 2nd word: cursor position offset for inner loop (h: row | l: col)
; 3rd word: cursor position offset (h: row | l: col)
data:
            dw    0x080c,0x0001,0x0101      ;horizontal
            dw    0x100c,0x0001,0xff01      ;horizontal
            dw    0x0410,0x0100,0x0101      ;vertical
            dw    0x0418,0x0100,0x00ff      ;vertical
