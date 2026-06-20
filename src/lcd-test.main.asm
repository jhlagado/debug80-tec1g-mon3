; TEC-1G LCD test program (MON-3, app @ 0x4000)
; Purpose: writes a multi-line message to the HD44780 LCD
;          exercising all 4 rows and some special characters.
;
; Uses: A, HL
; Clobbers: B (in delay)

        .org    0x4000

LCD_CMD     .equ    0x04
LCD_DATA    .equ    0x84

; HD44780 20x4 DDRAM addresses
LINE1       .equ    0x80            ; 0x00
LINE2       .equ    0xC0            ; 0x40
LINE3       .equ    0x94            ; 0x14
LINE4       .equ    0xD4            ; 0x54

START:
        LD      A,0x01          ; clear display
        OUT     (LCD_CMD),A
        CALL    LCD_DELAY

        ; --- Line 1 ---
        LD      A,LINE1
        OUT     (LCD_CMD),A
        CALL    LCD_DELAY
        LD      HL,MSG1
        CALL    LCD_STRING

        ; --- Line 2 ---
        LD      A,LINE2
        OUT     (LCD_CMD),A
        CALL    LCD_DELAY
        LD      HL,MSG2
        CALL    LCD_STRING

        ; --- Line 3 ---
        LD      A,LINE3
        OUT     (LCD_CMD),A
        CALL    LCD_DELAY
        LD      HL,MSG3
        CALL    LCD_STRING

        ; --- Line 4 ---
        LD      A,LINE4
        OUT     (LCD_CMD),A
        CALL    LCD_DELAY
        LD      HL,MSG4
        CALL    LCD_STRING

DONE:
        JP      DONE

; --- Print null-terminated string at HL to LCD ---
LCD_STRING:
        LD      A,(HL)
        OR      A
        RET     Z
        OUT     (LCD_DATA),A
        CALL    LCD_DELAY
        INC     HL
        JR      LCD_STRING

; --- Short busy-wait ---
LCD_DELAY:
        LD      B,0x40
DELAY_LOOP:
        DJNZ    DELAY_LOOP
        RET

; --- Messages ---
MSG1:   .db      "TEC-1G  HD44780 LCD",0
MSG2:   .db      "Z80 @ 3.58MHz",0
MSG3:   .db      0xE0,0xE2,0xE4,0xE5," ",0xF4," Hello World!",0        ; alpha beta mu sigma  Omega
MSG4:   .db      0xB1,0xB2,0xB3,0xB4,0xB5," ",0xB6,0xB7,0xB8,0xB9,0xBA," TEC-1G",0  ; katakana: アイウエオ カキクケコ
