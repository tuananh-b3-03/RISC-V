# AXI4 RAM Notes

This project now includes `axi4_ram.v`, a synthesizable AXI4 RAM slave.

## What Was Added

- 32-bit data bus by default.
- 10-bit address bus by default, giving 1 KB of RAM.
- AXI write address, write data, write response, read address, and read data channels.
- Byte write strobes through `s_axi_wstrb`.
- Single outstanding read transaction.
- Single outstanding write transaction.
- Incrementing bursts through `AWBURST/ARBURST = 2'b01`.

## Important Integration Note

The current RISC-V datapath is **not** an AXI master. It currently talks to data
memory with this simple direct interface:

```verilog
Data_Memory comp20(clk, ALU_outM, WriteDataM, ReadDataM, MemWriteM);
```

That interface expects `ReadDataM` to be available immediately from the address.
AXI reads are handshake-based and normally take at least one clock cycle. Because
of that, replacing `Data_Memory` directly with AXI RAM would require:

- an AXI master/load-store adapter,
- memory-stage stall control,
- pipeline hold/flush changes while AXI read data is pending,
- write-response handling.

So `axi4_ram.v` has been added to the project as a clean RAM block, but the CPU
datapath still uses the original `Data_Memory.v` until the bus adapter and stall
logic are added.

## Default Parameters

```verilog
axi4_ram #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(10),
    .ID_WIDTH(4)
) ram (...);
```

`ADDR_WIDTH = 10` means byte addresses from `0x000` to `0x3FF`, or 256 32-bit
words.
