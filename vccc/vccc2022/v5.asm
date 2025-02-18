%line       1 "v5.asm"

; Vintage Computing Christmas Challenge 2022
; Jose Moreno Prieto - Xeleh
; 20/12/2022

            org     100h
            section .text

; number of lines to print
            mov     dx,17

; print spaces and stars (twice per line)
l1          mov     ah,[data+bx]    ; ah = number of spaces | number of stars
            inc     bx
            pushf
            mov     al,' '
            mov     cl,ah
            shr     cl,4            ; cl = number of spaces
            jz      $+5             ; skip loop if number of spaces is zero
l2          int     29h
            loop    l2
            mov     al,'*'
            mov     cl,ah
            and     cl,0fh          ; cl = number of stars
l3          int     29h             ; no jz needed: number of stars is never zero
            loop    l3
            popf
            cmc
            jc      l1

; print eol chars
            mov     al,13
            int     29h
            mov     al,10
            int     29h

; next line
            dec     dx
            jnz     l1

%ifdef      debug
            waitkey
%endif
            ret

; each line is coded using two bytes, where each byte contains:
; - 4 upper bits -> number of ' ' to print (can be zero)
; - 4 lower bits -> number of '*' to print
data:
            db      41h,71h         ;     *|       *     
            db      42h,52h         ;     **|     **     
            db      43h,33h         ;     ***|   ***     
            db      44h,14h         ;     ****| ****     
            db      0fh,02h         ; ***************|** 
            db      1eh,01h         ;  **************|*  
            db      2ch,01h         ;   ************|*   
            db      3ah,01h         ;    **********|*    
            db      48h,01h         ;     ********|*     
            db      3ah,01h         ;    **********|*    
            db      2ch,01h         ;   ************|*   
            db      1eh,01h         ;  **************|*  
            db      0fh,02h         ; ***************|** 
            db      44h,14h         ;     ****| ****     
            db      43h,33h         ;     ***|   ***     
            db      42h,52h         ;     **|     **     
            db      41h,71h         ;     *|       *     
