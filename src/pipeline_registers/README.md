# Pipeline Registers – RV32IM 5-Stage Processor

This folder contains all **pipeline register modules** connecting the stages of the RV32IM 5-stage pipeline.
These registers hold the required signals between pipeline stages, handle **flushes** and **enables** from the hazard unit, and ensure correct instruction propagation across the pipeline.

---

## 📂 Folder Structure

* **if_id_pipeline.v** – Registers between **IF → ID** stage.
* **id_ex_pipeline.v** – Registers between **ID → EX** stage.
* **ex_mem_pipeline.v** – Registers between **EX → MEM** stage.
* **mem_wb_pipeline.v** – Registers between **MEM → WB** stage.

---

## 🚀 Features

* **Flush and Enable signals** in IF/ID and ID/EX registers

  * Provided by the hazard unit
  * On flush, all signals are set to those of a **NOP instruction**
  * Enable allows stalling the pipeline

* **Synchronous pipeline registers** for EX/MEM and MEM/WB stages.

* Modular design to easily extend or modify the pipeline.

---

## 📌 Key Design Points

1. **No instruction register in IF/ID stage**

   * Instruction memory has a **1-cycle synchronous read**, so the instruction is already delayed by 1 cycle.
   * An extra instruction register is unnecessary.

2. **No memory result register in MEM/EX stage**

   * Data memory read is synchronous, introducing **1-cycle latency**.
   * No additional MEM/EX register is needed for `mem_result`.

3. **Flush & Enable Signals**

   * IF/ID and ID/EX pipeline registers are equipped with `flush` and `enable` signals from the hazard unit.
   * Flushing sets all pipeline signals to a **NOP instruction**.
   * Enable allows pipeline stalling without corrupting data.

---

*Created by Talha Israr*
