# ASAP7 FinFET Circuit Design & Characterization
### 7nm Predictive Process Node | Xschem + Ngspice | BSIMCMG OSDI Compact Model

<p align="left">
  <img src="https://img.shields.io/badge/PDK-ASAP7%20Predictive-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Node-7nm%20FinFET-green?style=flat-square" />
  <img src="https://img.shields.io/badge/Simulator-Ngspice-orange?style=flat-square" />
  <img src="https://img.shields.io/badge/Schematic-Xschem-purple?style=flat-square" />
  <img src="https://img.shields.io/badge/Model-BSIMCMG%20v107-red?style=flat-square" />
  <img src="https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square" />
</p>

---

## Overview

This repository documents a progressive, hands-on characterization and design flow for **7nm FinFET** circuits using the **ASAP7 Predictive Design Kit (PDK)** developed at Arizona State University. All schematics are drawn in **Xschem** and simulated using **Ngspice** with the industry-standard **BSIMCMG OSDI** compact model loaded via the OpenVAF-compiled shared library (`bsimcmg.osdi`).

The project progresses from foundational transistor characterization through standard-cell-level analysis and culminates in an analog mixed-signal design — a fully self-contained **Bandgap Reference (BGR)** circuit targeting process-independent voltage stability across a −45 °C to +125 °C operating range.

> **Note:** This is a *predictive* PDK intended for academic research and architecture exploration. ASAP7 is not a foundry-certified process; it is calibrated to approximately represent the electrical behavior expected from an industrial 7nm FinFET technology and is widely used in published research for pre-silicon design space exploration.

---

## Repository Structure

```
asap7-finfet-design/
├── README.md                    ← This file — toolchain overview & PDK reference
├── .gitignore                   ← Filters simulation artifacts, swap files, OSDI binaries
│
├── 1_FET_Characteristics/       ← NMOS/PMOS DC characterization (Id-Vds, Id-Vgs)
│   ├── README.md
│   ├── nfet_char.sch            ← Xschem schematic for NMOS characterization
│   ├── nfet_char.spice          ← Exported SPICE netlist (Id-Vds family sweep)
│   ├── pfet_char.spice          ← PMOS counterpart with mirrored biasing
│   └── images/
│
├── 2_Finfet_Inverter/           ← CMOS inverter VTC, propagation delay, noise margins
│   ├── README.md
│   ├── inverter_vtc.sch         ← Xschem schematic — VTC DC sweep configuration
│   ├── inverter_finfet.sch      ← Xschem schematic — transient pulse configuration
│   ├── inverter_vtc.spice       ← Full SPICE deck: DC + transient + NM + delay
│   ├── inverter_finfet.spice    ← Transient-only deck (rise/fall timing)
│   └── images/
│
└── 3_Bandgap_Reference/         ← Self-biased current mirror BGR (PTAT/CTAT/startup)
    ├── README.md
    ├── bgrcircuit.sch            ← Full Xschem schematic of BGR with startup circuit
    ├── bgr_temp_sweep.spice      ← SPICE deck: .dc temp sweep −45 to +125 °C
    └── images/
```

---

## Technology: ASAP7 Predictive 7nm PDK

The ASAP7 PDK models a **7nm bulk-like FinFET** process using the BSIMCMG (BSIM Common Multi-Gate) compact model at version 107. Key technology parameters extracted from the embedded model cards used in this repository are tabulated below.

### Process Technology Parameters

| Parameter | NMOS (Type=1) | PMOS (Type=0) | Unit |
|---|---|---|---|
| Gate Length (L) | 7 | 7 | nm |
| Fin Pitch (`fpitch`) | 27 | 27 | nm |
| Fin Height (`hfin`) | 32 | 32 | nm |
| Fin Width / Thickness (`tfin`) | 6.5 | 6.5 | nm |
| Number of Fins (`nfin`, typical) | 14 | 14 | — |
| Gate Oxide Thickness (`toxg`) | 1.80 | 1.80 | nm |
| Physical Gate Oxide (`toxp`) | 2.1 | 2.1 | nm |
| Equivalent Oxide Thickness (`eot`) | 1.0 | 1.0 | nm |
| Gate Work Function (`phig`) | 4.2466 | 4.9278 | eV |
| Body Doping (`nbody`) | 1×10²² | 1×10²² | cm⁻³ |
| Source/Drain Doping (`nsd`) | 2×10²⁶ | 2×10²⁶ | cm⁻³ |
| Low-Field Mobility (`u0`) | 0.0303 | 0.0237 | m²/V·s |
| Saturation Velocity (`vsat`) | 70000 | 60000 | m/s |
| Gate-Source Overlap Cap (`cgso`) | 1.6×10⁻¹⁰ | 1.6×10⁻¹⁰ | F/m |
| DIBL Coefficient (`eta0`) | 0.07 | 0.094 | — |
| Drain Saturation Slope (`dsub`) | 0.35 | 0.24 | — |
| Thermal Resistance (`rth0`) | 0.225 | 0.15 | K·m/W |
| Nominal Temperature (`tnom`) | 25 | 25 | °C |
| Bulk Modulus (`bulkmod`) | 1 | 1 | — |

### Supply Voltage & Bias Conventions

| Parameter | Value |
|---|---|
| Nominal VDD (digital / inverter) | **0.7 V** |
| Nominal VDD (BGR analog) | **1.75 V** |
| NMOS threshold voltage (estimated) | ~0.25–0.30 V |
| PMOS threshold voltage (estimated) | ~−0.30 V |
| Recommended Vgs sweep range | 0 → VDD |
| Recommended Vds sweep range | 0 → VDD (step 0.1 V) |

> The digital supply of 0.7 V is characteristic of 7nm nodes and reflects the aggressive voltage scaling needed to maintain power density targets as transistor density increases. The BGR operates at 1.75 V to accommodate the PTAT/CTAT headroom requirements of the self-biased topology.

---

## Compact Model: BSIMCMG v107 via OSDI

The ASAP7 PDK requires the **BSIMCMG** model compiled to the **OSDI** (Open Standard for Device Integration) interface, delivered as `bsimcmg.osdi`. This shared library is loaded at the start of every simulation via an Ngspice control block:

```spice
.control
pre_osdi /path/to/bsimcmg.osdi
.endc
```

The device subcircuit declarations follow a consistent four-terminal pattern:

```spice
* NMOS FinFET subcircuit
.subckt asap_7nm_nfet S G D B l=7e-009 nfin=14
    nnmos_finfet S G D B BSIMCMG_osdi_N l=7e-009 nfin=14
.ends asap_7nm_nfet

* PMOS FinFET subcircuit
.subckt asap_7nm_pfet S G D B l=7e-009 nfin=14
    npmos_finfet S G D B BSIMCMG_osdi_P l=7e-009 nfin=14
.ends asap_7nm_pfet
```

The `nfin` parameter is the primary transistor sizing knob. Since fins are quantized, W_eff = nfin × (2 × hfin + tfin). For `nfin=14`: W_eff ≈ 14 × (2 × 32 + 6.5) nm = **14 × 70.5 nm ≈ 987 nm**.

---

## Tool Setup & Environment

### 1. Xschem

Xschem is the schematic capture tool used to draw all circuits in this project and export SPICE netlists.

**Installation (Ubuntu/Debian):**
```bash
sudo apt-get install xschem
```

**From source (recommended for latest features):**
```bash
git clone https://github.com/StefanSchippers/xschem.git
cd xschem
./configure
make && sudo make install
```

Launch with the ASAP7 symbols in this repo:
```bash
xschem --rcfile ~/.xschem/xschemrc <schematic_name>.sch
```

> The custom `asap_7nm_nfet.sym` and `asap_7nm_pfet.sym` symbol files must reside in the same directory as the schematic, or the Xschem symbol search path (`xschemrc`) must be configured to include the repository root.

### 2. Ngspice

Ngspice is the open-source SPICE simulator used for all DC, transient, and temperature sweep analyses.

**Installation:**
```bash
sudo apt-get install ngspice
```

**Check OSDI support** (required for BSIMCMG):
```bash
ngspice --version | grep -i osdi
```

If OSDI support is absent, Ngspice must be compiled from source with `--enable-osdi`:
```bash
./configure --with-x --enable-xspice --enable-cider --enable-osdi \
            --disable-debug CFLAGS="-m64 -O2"
make -j$(nproc) && sudo make install
```

**Running a simulation:**
```bash
ngspice -b <netlist_name>.spice
```
The `-b` flag runs in batch mode; remove it for interactive waveform plotting via the Ngspice GUI.

### 3. OSDI / BSIMCMG Binary

The pre-compiled `bsimcmg.osdi` is included in this repository **for convenience only**. If it fails to load (architecture mismatch), recompile:

```bash
# Install OpenVAF
cargo install openvaf

# Compile from the BSIM source VA file
openvaf bsimcmg.va --output bsimcmg.osdi
```

**Update the `.osdi` path** in each `.spice` file to match your local installation before running:
```spice
.control
pre_osdi /absolute/path/to/bsimcmg.osdi
.endc
```

---

## Simulation Projects

### [1. FET Characteristics](./1_FET_Characteristics/)

DC characterization of the 7nm NMOS and PMOS FinFETs.

- **Id-Vds** output characteristics (family of curves, Vgs stepped 0 → VDD)
- **Id-Vgs** transfer characteristics (linear and log scale, Vds = VDD/2 and VDD)
- Threshold voltage extraction, subthreshold slope, DIBL extraction

### [2. FinFET Inverter](./2_Finfet_Inverter/)

CMOS inverter characterization at 7nm targeting 0.7 V operation.

- **Voltage Transfer Characteristic (VTC):** DC sweep, switching threshold (V_th), noise margins (NMH, NML), peak gain
- **Transient Analysis:** Propagation delay (t_pLH, t_pHL), rise/fall times at a 500 ps period
- **Power Estimation:** Dynamic switching power from transient current integration

### [3. Bandgap Reference](./3_Bandgap_Reference/)

Full analog circuit design — self-biased current mirror based BGR with PTAT, CTAT, startup, and reference branches.

- **Target V_ref:** 1.6 V ± 32 mV (2% inaccuracy spec)
- **Supply:** VDD = 1.75 V, I_branch = 10 µA per branch (3 branches = 30 µA total)
- **Temperature sweep:** −45 °C to +125 °C in 5 °C steps
- **Key resistors:** R1 = 33 kΩ (PTAT), R2 = 50 kΩ (reference summing)

---

## Waveform Capture Workflow

All simulations are run locally. The image placeholders in each sub-folder README are populated after running the `.spice` decks and exporting PNG captures from the Ngspice waveform viewer.

**Recommended Ngspice → PNG export:**
```bash
# Inside .control block, add:
hardcopy ./images/<plotname>.ps <node_expression>
# Then convert:
ps2pdf ./images/<plotname>.ps && convert ./images/<plotname>.pdf ./images/<plotname>.png
```

Or interactively via the Ngspice GUI: **File → Print → PNG**.

---
