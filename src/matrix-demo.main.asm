; TEC-1G 8x8 RGB matrix demo (MON-3 layout, RAM @ 0x4000).
; TEC-Expander 8x8 RGB:
;     OUT 0x05 = row select (0 = no row / blank between updates)
;     OUT 0x06 = red columns
;     OUT 0xF8 = green columns
;     OUT 0xF9 = blue columns
;
; Scan sequence per line: row off -> latch R,G,B column bytes -> row on -> hold.
; Bitmap layout: 24 bytes interleaved by row — for each row i:
;     (R_i, G_i, B_i) so one pointer walk loads a full colour row in order.
;
; Pattern below: classic smiley shape; face is yellow (R+G), no blue on the face.

        .org     0x4000

PORT_ROW:       .equ     0x05
PORT_RED:       .equ     0x06
PORT_GREEN:     .equ     0xF8
PORT_BLUE:      .equ     0xF9

ROW_COUNT:      .equ     8
ROLL_FRAMES:    .equ     0xFF
BYTES_PER_ROW:  .equ     3

START:  LD      C,0x01
        LD      DE,ROLL_FRAMES
FRAME:  LD      HL,BITMAP
        PUSH    DE
        LD      D,C
        LD      B,ROW_COUNT
ROWLP:  XOR     A
        OUT     (PORT_ROW),A
        LD      A,(HL)
        OUT     (PORT_RED),A
        INC     HL
        LD      A,(HL)
        OUT     (PORT_GREEN),A
        INC     HL
        LD      A,(HL)
        OUT     (PORT_BLUE),A
        INC     HL
        LD      A,D
        OUT     (PORT_ROW),A
        RLC     D
        DJNZ    ROWLP
        POP     DE
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ, FRAME
        LD      E,ROLL_FRAMES
        RLC     C
        JR      FRAME

; Interleaved RGB rows (8 rows x 3 bytes). Same smiley silhouette on R and G
; gives yellow; B plane 0 on the face. Tweak any triplet for 8-colour pixels.
BITMAP:
        .db      %00111100, %00000000, %11000011
        .db      %01000010, %00000000, %10111101
        .db      %10100101, %00100100, %01111110
        .db      %10000001, %00000000, %01111110
        .db      %10000001, %00100100, %01011010
        .db      %10000001, %00011000, %01100110
        .db      %01000010, %00000000, %10111101
        .db      %00111100, %00000000, %11000011
