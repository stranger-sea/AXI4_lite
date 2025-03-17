# AXI4_lite

key components:
AXI Master Modules:
axi_master_w: Handles write operations, managing address, data, and response phases (AW, W, and B channels) with state machines for each phase.
axi_master_r: Manages read operations, controlling address and data phases (AR and R channels) with appropriate state transitions.
AXI Slave Modules:
axi_slave_w: Processes write requests from the master, generating ready signals and capturing write data and addresses.
axi_slave_r: Handles read requests, providing read data and response signals to the master.
Top-Level Module (axi_top):
Integrates the master and slave modules, connecting CPU signals (write/read enable, addresses, and data) to memory signals. It facilitates a complete AXI transaction flow, including wire connections for AXI channels (AW, W, B, AR, R).


Features:
Supports 32-bit address and data buses.
Implements AXI4-lite protocol with basic handshake mechanisms (VALID/READY signals).
Includes state machine-based control for address, data, and response phases.
Compatible with simulation environments (e.g., Cadence SimVision, as seen in the schematic tracer).

Usage:
The project can be synthesized and simulated using Verilog-compatible tools (e.g., ModelSim, Vivado, or Cadence tools).
The included testbench infrastructure (e.g., axi_top_tb) allows for waveform-based verification of AXI transactions.


This project was developed as a learning exercise in AXI protocol implementation and hardware design.
