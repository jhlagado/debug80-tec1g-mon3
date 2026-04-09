; TEC-1G 8x8 RGB matrix demo (MON-3 layout, RAM @ 0x4000).
; TEC-Expander 8x8 RGB column ports:
;     OUT 0x05 = row select
;     OUT 0x06 = red columns
;     OUT 0xF8 = green columns
;     OUT 0xF9 = blue columns
; Same smiley bitmap as matrix-demo.asm; cycles through all 8 colours (incl black).

        ORG     0x4000

PORT_ROW:       EQU     0x05
PORT_RED:       EQU     0x06
PORT_GREEN:     EQU     0xF8
PORT_BLUE:      EQU     0xF9

ROW_COUNT:      EQU     8
ROLL_FRAMES:    EQU     8

COLOR:          DB      0

START:  LD      C,0x01
        LD      E,ROLL_FRAMES

FRAME:  LD      HL,ROW_DATA
        LD      D,C
        LD      B,ROW_COUNT
ROWLP:  XOR     A
        OUT     (PORT_RED),A
        OUT     (PORT_GREEN),A
        OUT     (PORT_BLUE),A
        LD      A,D
        OUT     (PORT_ROW),A
        LD      A,(HL)
        LD      (SHAPE),A
        CALL    OUT_RGB
        CALL    DELAY
        INC     HL
        RLC     D
        DJNZ    ROWLP

        DEC     E
        JR      NZ, FRAME
        LD      E,ROLL_FRAMES
        RLC     C
        LD      A,(COLOR)
        INC     A
        AND     0x07
        LD      (COLOR),A
        JR      FRAME

; Apply smiley shape to each colour plane: pixel on iff shape bit set AND colour bit set.
; Preserves BC/DE/HL (B=row count, C=roll mask, E=frame count).
OUT_RGB:PUSH    BC
        LD      A,(COLOR)
        LD      C,A
        LD      A,(SHAPE)
        LD      B,A
        LD      A,C
        BIT     0,A
        JR      Z, RED_OFF
        LD      A,B
        JR      RED_OUT
RED_OFF:XOR     A
RED_OUT:OUT     (PORT_RED),A
        LD      A,C
        BIT     1,A
        JR      Z, GRN_OFF
        LD      A,B
        JR      GRN_OUT
GRN_OFF:XOR     A
GRN_OUT:OUT     (PORT_GREEN),A
        LD      A,C
        BIT     2,A
        JR      Z, BLU_OFF
        LD      A,B
        JR      BLU_OUT
BLU_OFF:XOR     A
BLU_OUT:OUT     (PORT_BLUE),A
        POP     BC
        RET

DELAY:  PUSH    BC
        LD      B,0x1
D1:     LD      C,0xFF
D2:     DEC     C
        JR      NZ,D2
        DJNZ    D1
        POP     BC
        RET

SHAPE:  DB      0

ROW_DATA:
        DB      %00111100
        DB      %01000010
        DB      %10100101
        DB      %10000001
        DB      %10100101
        DB      %10011001
        DB      %01000010
        DB      %00111100
