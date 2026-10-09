# Experiment 4 – 8×8 RAM Verification using SystemVerilog

## 📌 Experiment Title

**Functional Verification of an 8×8 RAM using SystemVerilog OOP-based Testbench**

---

## 🎯 Objective

To design an **8×8 synchronous RAM** and verify its read and write functionality using a SystemVerilog **object-oriented verification environment** consisting of:

- Transaction
- Generator
- Driver
- Monitor
- Scoreboard
- Environment
- Testbench

The verification environment uses a **reference memory model** in the scoreboard to compare the expected RAM output with the actual DUT output.

---

## 🧩 Design Under Test (DUT)

The RAM contains:

- **8 memory locations**
- **8-bit data width**
- **3-bit write address**
- **3-bit read address**
- Synchronous read/write operation
- Active-high reset

### RAM Interface

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 | Clock |
| `reset` | 1 | Active-high reset |
| `wr_en` | 1 | Write enable |
| `wr_add` | 3 | Write address |
| `rd_add` | 3 | Read address |
| `data_in` | 8 | Input data |
| `data_out` | 8 | Output data |

---

## 🏗️ Verification Environment

The testbench follows a basic SystemVerilog OOP verification architecture:

```text
                 ┌──────────────┐
                 │   Generator  │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │    Driver    │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │     DUT      │
                 │    8×8 RAM   │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │   Monitor    │
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │  Scoreboard  │
                 └──────────────┘
```

---

## 📄 File Description

### `design.sv`

Contains the **8×8 RAM RTL design**.

The RAM performs:

```text
wr_en = 1 → Write data
wr_en = 0 → Read data
```

The memory is reset to zero when `reset` is asserted.

---

### `interface.sv`

Defines the SystemVerilog interface used to connect the DUT with the verification components.

It contains:

```text
clk
reset
wr_en
wr_add
rd_add
data_in
data_out
```

---

### `transaction.sv`

Defines the transaction object used to transfer stimulus between the generator, driver, monitor, and scoreboard.

The transaction contains:

```text
wr_en
wr_add
rd_add
data_in
data_out
```

---

### `generator.sv`

Generates randomized RAM transactions.

The experiment generates:

```text
20 transactions
```

Each transaction contains a randomized:

- Write enable
- Write address
- Read address
- Input data

---

### `driver.sv`

Receives transactions from the generator and drives them onto the DUT interface.

The driver applies signals on the **negative edge of the clock** so that the inputs are stable before the DUT samples them at the positive edge.

```text
negedge → Driver drives inputs
posedge → DUT samples inputs
```

---

### `monitor.sv`

Observes the DUT interface and captures the transactions.

The monitor samples at the positive edge of the clock and waits briefly for the DUT's nonblocking assignments to update:

```systemverilog
@(posedge inv.clk);
#1;
```

It then sends the observed transaction to the scoreboard.

---

### `scoreboard.sv`

Contains the **reference memory model**.

```systemverilog
bit [7:0] ref_mem [0:7];
```

The scoreboard:

1. Checks the previous cycle's read result.
2. Updates the reference memory for write operations.
3. Stores the current read address for checking during the next cycle.

Expected and actual values are compared using:

```systemverilog
!== 
```

This allows unknown (`X`) and high-impedance (`Z`) values to be detected as mismatches.

---

### `environment.sv`

Creates and connects all verification components:

```text
Generator
Driver
Monitor
Scoreboard
```

It also creates the mailboxes required for communication between components.

---

### `test.sv`

Starts the verification environment and allows sufficient simulation time for the generated transactions to complete.

---

### `testbench.sv`

The top-level simulation module.

It:

- Generates the clock
- Instantiates the interface
- Instantiates the RAM DUT
- Connects the DUT to the interface
- Applies reset
- Creates and starts the test

---

## 🔄 Verification Flow

The complete flow is:

```text
Random Transaction
       ↓
    Generator
       ↓
     Mailbox
       ↓
     Driver
       ↓
   RAM (DUT)
       ↓
    Monitor
       ↓
     Mailbox
       ↓
   Scoreboard
       ↓
Compare Expected vs Actual
```

---

## ⏱️ Clocking Scheme

The experiment uses separate clock phases for driving and sampling.

### Driver

```systemverilog
@(negedge inv.clk);
```

The driver changes inputs on the negative edge.

### DUT

```systemverilog
@(posedge clk);
```

The RAM samples inputs on the positive edge.

### Monitor

```systemverilog
@(posedge inv.clk);
#1;
```

The monitor samples the output after the DUT has updated its registered output.

This avoids race conditions between the DUT and monitor.

---

## 🧠 Scoreboard Reference Model

The scoreboard maintains its own memory:

```text
ref_mem[0] → expected data
ref_mem[1] → expected data
...
ref_mem[7] → expected data
```

For a write:

```text
wr_en = 1
wr_add = 3
data_in = 160
```

the reference model performs:

```text
ref_mem[3] = 160
```

For a read:

```text
wr_en = 0
rd_add = 3
```

the scoreboard expects:

```text
data_out = ref_mem[3]
```

---

## ✅ PASS Condition

A transaction passes when:

```text
Actual data_out == Expected reference memory value
```

Example:

```text
SCOREBOARD PASS: addr=3 data=160
```

---

## ❌ FAIL Condition

A transaction fails when:

```text
Actual data_out != Expected reference memory value
```

Example:

```text
SCOREBOARD ERROR: addr=3 expected=160 got=0
```

This indicates a mismatch between the DUT and the reference model.

---

## 🛠️ Tools Used

- **SystemVerilog**
- **Synopsys VCS**
- Linux/Unix simulation environment
- Object-Oriented Programming concepts
- Mailbox-based communication

---

## ▶️ Compilation and Simulation

Using Synopsys VCS:

```bash
vcs -sverilog design.sv testbench.sv
```

Run the simulation:

```bash
./simv
```

For waveform/debug support, VCS options such as `-debug_access+all` can also be used.

---

## 📊 Expected Simulation

The simulation displays messages from the different verification components.

Example:

```text
GENERATOR
wr_en=1 , wr_add=7 , rd_add=5 , data_in=211

DRIVER
wr_en=1 , wr_add=7 , rd_add=5 , data_in=211

MONITOR
wr_en=1 , wr_add=7 , rd_add=5 , data_in=211

REFERENCE MODEL: mem[7] = 211

...

SCOREBOARD PASS: addr=7 data=211
```

For a mismatch:

```text
❌ SCOREBOARD ERROR:
addr=7 expected=211 got=0
```

---

## 📚 Concepts Demonstrated

This experiment demonstrates the following SystemVerilog verification concepts:

- Classes
- Objects
- Constructors
- Randomization
- Mailboxes
- Virtual interfaces
- Object-oriented testbench architecture
- Generator
- Driver
- Monitor
- Scoreboard
- Environment
- Reference model
- Synchronous RAM
- Nonblocking assignments
- Clock synchronization
- Functional checking
- DUT vs reference-model comparison

---

## 🎓 Learning Outcome

After completing this experiment, the student should understand how to:

1. Design an 8×8 RAM in Verilog/SystemVerilog.
2. Create transactions using SystemVerilog classes.
3. Generate randomized stimulus.
4. Drive transactions into a DUT.
5. Monitor DUT activity.
6. Communicate between testbench components using mailboxes.
7. Create a reference model.
8. Compare expected and actual results using a scoreboard.
9. Understand clock synchronization in a verification environment.
10. Build a basic OOP-based SystemVerilog verification environment.

---

## 🚀 Future Improvements

The verification environment can be extended with:

- Functional coverage
- Assertions
- Constrained randomization
- Clocking blocks
- Interfaces with modports
- More sophisticated reference models
- Error injection
- Coverage-driven verification
- SystemVerilog Assertions (SVA)
- UVM-based verification

---

## 👨‍💻 Author

**G.Siva Sankar Reddy**

