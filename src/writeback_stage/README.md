# Writeback Stage Module

This folder contains the implementation of the **Writeback (WB) stage** for the RV32IM 5-stage pipelined processor.
The WB stage selects the correct value to write back to the register file based on whether the instruction is a **load** or an **ALU operation**.

## 📂 Folder Structure

* **writeback_stage.v**
  RTL Verilog file implementing the WB stage.

* **README.md**
  This documentation file.

## 🚀 Features

* Simple combinational logic
* Selects between **memory read data** and **ALU result**
* Outputs the value to be written back to the register file

## 📜 How It Works

Ports:

| Name            | Direction | Width | Description                                     |
| --------------- | --------- | ----- | ----------------------------------------------- |
| `wb_load`       | input     | 1     | High if instruction is a memory load            |
| `mem_read_data` | input     | 32    | Data read from memory (for load instructions)   |
| `alu_result`    | input     | 32    | Result from the ALU (for non-load instructions) |
| `wb_result`     | output    | 32    | Data to write back to the register file         |

Behavior:

* If `wb_load` is high, `wb_result` = `mem_read_data`
* Otherwise, `wb_result` = `alu_result`

```verilog
assign wb_result = wb_load ? mem_read_data : alu_result;
```

## 📊 Block Diagram

![Writeback Stage](../../imgs/stages/rv32im_wb_stage.png)

## 📌 Notes

* This module is fully combinational and designed to be lightweight.
* It is compatible with the 5-stage RV32IM pipeline design.

---

*Created by Talha Israr*
