%line       1 "v7.asm"

; Vintage Computing Christmas Challenge 2022
; Jose Moreno Prieto - Xeleh
; 28/12/2022

            org     100h
            section .text

            int     10h             ; 40x25 text mode
            mov     si,data
            mov     cl,4            ; 4 triangles
l1          push    cx
            mov     dx,[si]         ; get initial cursor position
            mov     cl,13           ; initial line length in chars
l2          push    cx
            mov     ax,02h<<8|'*'   ; ah = 02h (bios set cursor position) | al = character to print
            int     10h             ; move cursor
l3          int     29h             ; print character
            loop    l3              ; next character
            add     dx,[si+2]       ; update cursor position
            pop     cx
            loop    l2              ; next line
            add     si,4
            pop     cx
            loop    l1              ; next triangle

%ifdef      debug
            waitkey
            ret                     ; exit to prompt not required by compo rules
%endif

; each pair of words define how to paint a triangle of 13 lines
; 1st word: initial cursor position (h: row | l:col)
; 2nd word: cursor position offset (h: row | l: col)
data:
            dw      0x0505,0x0100
            dw      0x0d01,0xff01
            dw      0x0d05,0xff00
            dw      0x0501,0x0101
