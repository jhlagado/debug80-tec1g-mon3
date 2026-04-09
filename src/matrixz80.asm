; ZAX lowered ASM80 output

ORG $0100
; ZAX port of matrix-demo.asm — same control flow and ports.
; Bitmap uses ld a,(hl) with HL walking the interleaved R,G,B rows.
; main() is emitted first so the image entry at $4000 is the program (not delay).
PORT_ROW EQU $05
PORT_RED EQU $06
PORT_GREEN EQU $F8
PORT_BLUE EQU $F9
ROW_COUNT EQU $08
ROLL_FRAMES EQU $08

ORG $4100
; RAM layout: code @ 0x4000, bitmap @ 0x4100 (24 bytes).
bitmap:
DB $3C
DB $3C
DB $00
DB $42
DB $42
DB $00
DB $A5
DB $A5
DB $00
DB $81
DB $81
DB $00
DB $A5
DB $A5
DB $00
DB $99
DB $99
DB $00
DB $42
DB $42
DB $00
DB $3C
DB $3C
DB $00

ORG $4000
; ZAX: func main begin
main:
ld c, $01
ld e, $08
frame:
DB $21, $00, $41   <--- why no opcodes, why no label
ld d, c
ld b, $08
rowlp:
xor a
out ($05), a
ld a, (HL)
out ($06), a
inc hl
ld a, (HL)
out ($F8), a
inc hl
ld a, (HL)
out ($F9), a
inc hl
ld a, d
out ($05), a
DB $CD, $2C, $40    <--- why no opcodes, why no label
rlc d
DB $10, $E7   <--- why no opcodes
dec e
DB $20, $DE   <--- why no opcodes
ld e, $08
rlc c
DB $18, $D8   <--- why no opcodes
; ZAX: func main end
; ZAX: func delay begin
delay:
push bc
ld b, $01
d1:
ld c, $FF
d2:
dec c
DB $20, $FD   <--- why no opcodes
DB $10, $F9   <--- why no opcodes
pop bc
ret
; ZAX: func delay end
