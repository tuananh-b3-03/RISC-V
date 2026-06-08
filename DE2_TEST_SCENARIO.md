# DE2 Manual Test Scenario

This project uses `RISC_FPGA.v` as the DE2 top level. The program in
`Instruction_Mem.v` now runs this scenario:

| PC | Instruction | Expected result |
| --- | --- | --- |
| `0x00` | `addi x1,x0,5` | `x1 = 5` |
| `0x04` | `addi x2,x0,7` | `x2 = 7` |
| `0x08` | `add x3,x1,x2` | `x3 = 12` |
| `0x0C` | `sw x3,0(x0)` | `DataMemory[0] = 12` |
| `0x10` | `lw x4,0(x0)` | `x4 = 12` |
| `0x14` | `beq x3,x4,+8` | Branch is taken, fail path is skipped |
| `0x1C` | `addi x5,x0,10` | `x5 = 10` |
| `0x20` | `add x6,x5,x3` | `x6 = 22` |
| `0x24` | `beq x0,x0,0` | CPU loops forever here |

## Board Controls

- `KEY[1]`: reset, active low. Press and release before starting.
- `SW[7] = 0`: manual clock from `KEY[0]`.
- `SW[7] = 1`: generated slow clock.
- `KEY[0]`: one manual clock step when `SW[7] = 0`.
- `SW[6:0]`: one-hot display selector for the HEX displays.

## Useful Display Selections

The HEX displays show the selected 32-bit value in hexadecimal.

| Switch value | Shows | What to expect near the end |
| --- | --- | --- |
| `0000001` | `PC_nowE` | Repeats at `00000024` after the loop is reached |
| `0000010` | `PCTargetE` | `00000024` on the final branch |
| `0000100` | `Rs1E` | Register index used by execute-stage source 1 |
| `0001000` | `Rs2E` | Register index used by execute-stage source 2 |
| `0010000` | `RdE` | Register index written by current execute instruction |
| `0100000` | `ReadDataM` | `0000000C` during/after the load from data memory |
| `1000000` | `WriteDataE` | `0000000C` during the store path |
| any other value | `ALU_outE` | `00000016` when `add x6,x5,x3` executes |

## Suggested Manual Run

1. Set `SW[7] = 0`.
2. Press and release `KEY[1]` to reset.
3. Set `SW[6:0] = 0000001` to watch `PC_nowE`.
4. Press `KEY[0]` slowly. The pipeline is five stages, so allow several presses
   before checking each expected value.
5. Change `SW[6:0]` to `0100000` and confirm the loaded value becomes
   `0000000C`.
6. Change `SW[6:0]` to the default/zero selection and confirm `ALU_outE` becomes
   `00000016` on the final add.
7. Return `SW[6:0]` to `0000001`; after the program finishes, the PC should stay
   around `00000024` because the final branch loops to itself.

## More Scenarios

To run one of these, replace only the `Imemory[...] = ...;` instruction lines in
`Instruction_Mem.v`. Keep the memory clear loop at the top of the `initial`
block.

### Scenario 2: Branch Not Taken

Purpose: proves that `beq` does not branch when operands differ.

Expected final values:

- `ALU_outE`: `0000000F` when `addi x4,x0,15` executes.
- `PC_nowE`: loops at `00000014`.

```verilog
Imemory[0] =32'b000000000101_00000_000_00001_0010011; // addi x1,x0,5
Imemory[4] =32'b000000000110_00000_000_00010_0010011; // addi x2,x0,6
Imemory[8] =32'b0000000_00010_00001_000_01000_1100011; // beq  x1,x2,+8
Imemory[12]=32'b000000001011_00000_000_00011_0010011; // addi x3,x0,11
Imemory[16]=32'b000000001111_00000_000_00100_0010011; // addi x4,x0,15
Imemory[20]=32'b0000000_00000_00000_000_00000_1100011; // beq  x0,x0,0
```

### Scenario 3: Logic And Shift Instructions

Purpose: tests `slli`, `ori`, `andi`, `xori`, and `srl`.

Expected values:

- `x2 = 12`
- `x3 = 13`
- `x4 = 13`
- `x5 = 2`
- `x6 = 1`
- Final `PC_nowE`: loops at `00000018`.

```verilog
Imemory[0] =32'b000000000011_00000_000_00001_0010011; // addi x1,x0,3
Imemory[4] =32'b000000000010_00001_001_00010_0010011; // slli x2,x1,2
Imemory[8] =32'b000000000001_00010_110_00011_0010011; // ori  x3,x2,1
Imemory[12]=32'b000000001101_00011_111_00100_0010011; // andi x4,x3,13
Imemory[16]=32'b000000001111_00100_100_00101_0010011; // xori x5,x4,15
Imemory[20]=32'b0000000_00001_00010_101_00110_0110011; // srl  x6,x2,x1
Imemory[24]=32'b0000000_00000_00000_000_00000_1100011; // beq  x0,x0,0
```

### Scenario 4: Memory With Nonzero Base And Offset

Purpose: checks address calculation for `sw` and `lw`.

Expected values:

- `ReadDataM`: `00000009` during/after the load.
- `ALU_outE`: `00000012` when `add x4,x3,x2` executes.
- Final `PC_nowE`: loops at `00000014`.

```verilog
Imemory[0] =32'b000000000100_00000_000_00001_0010011; // addi x1,x0,4
Imemory[4] =32'b000000001001_00000_000_00010_0010011; // addi x2,x0,9
Imemory[8] =32'b0000000_00010_00001_010_00010_0100011; // sw   x2,2(x1)
Imemory[12]=32'b000000000010_00001_010_00011_0000011; // lw   x3,2(x1)
Imemory[16]=32'b0000000_00010_00011_000_00100_0110011; // add  x4,x3,x2
Imemory[20]=32'b0000000_00000_00000_000_00000_1100011; // beq  x0,x0,0
```

### Scenario 5: Forwarding Chain

Purpose: stresses back-to-back dependent ALU instructions.

Expected values:

- `x1 = 1`
- `x2 = 2`
- `x3 = 3`
- `x4 = 5`
- `x5 = 8`
- `ALU_outE`: `00000008` when the final add executes.
- Final `PC_nowE`: loops at `00000014`.

```verilog
Imemory[0] =32'b000000000001_00000_000_00001_0010011; // addi x1,x0,1
Imemory[4] =32'b0000000_00001_00001_000_00010_0110011; // add  x2,x1,x1
Imemory[8] =32'b0000000_00001_00010_000_00011_0110011; // add  x3,x2,x1
Imemory[12]=32'b0000000_00010_00011_000_00100_0110011; // add  x4,x3,x2
Imemory[16]=32'b0000000_00011_00100_000_00101_0110011; // add  x5,x4,x3
Imemory[20]=32'b0000000_00000_00000_000_00000_1100011; // beq  x0,x0,0
```

### Scenario 6: LUI And AUIPC

Purpose: checks U-type immediate handling.

Expected values:

- `x1 = 00012000`
- `x2 = 00001004` for `auipc` at PC `0x04`
- `x3 = 00012005`
- `x4 = 00013009`
- Final `PC_nowE`: loops at `00000010`.

```verilog
Imemory[0] =32'b00000000000000010010_00001_0110111; // lui   x1,0x00012
Imemory[4] =32'b00000000000000000001_00010_0010111; // auipc x2,0x00001
Imemory[8] =32'b000000000101_00001_000_00011_0010011; // addi  x3,x1,5
Imemory[12]=32'b0000000_00011_00010_000_00100_0110011; // add   x4,x2,x3
Imemory[16]=32'b0000000_00000_00000_000_00000_1100011; // beq   x0,x0,0
```
