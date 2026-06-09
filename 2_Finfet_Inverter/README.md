# 2. FinFET Inverter — VTC, Noise Margins & Propagation Delay

**Technology:** ASAP7 7nm FinFET | **Tool:** Ngspice + Xschem | **Analysis:** `.dc` + `.tran`

---

## Objective

This module characterizes a minimum-sized 7nm CMOS inverter operating at **VDD = 0.7 V**, targeting four areas of analysis: the static **Voltage Transfer Characteristic (VTC)**, extraction of **noise margins** (NMH and NML), **propagation delay** (t_pLH, t_pHL), and **dynamic power** estimation from transient current integration. Both a dedicated DC schematic (`inverter_vtc.sch`) and a transient schematic (`inverter_finfet.sch`) are provided.

---

## Circuit Description

### Schematic Topology

Both schematics implement the same canonical CMOS complementary inverter:

```
         VDD (0.7 V)
              │
     S ───── VDD
  G ─┤ Xpfet1 (asap_7nm_pfet, l=7nm, nfin=14)
     D ───── nfet_out ──── Output
     │
  G ─┤ Xnfet1 (asap_7nm_nfet, l=7nm, nfin=14)
     S ───── GND
              │
            GND
```

Input stimulus `V1` is applied between node `nfet_in` (the common gate) and `GND`. Both the PMOS source and NMOS source are connected to their respective supply rails. Bulk connections follow the ASAP7 convention: **PMOS bulk = VDD**, **NMOS bulk = GND**.

**Transistor sizing (both NMOS and PMOS):**
- `l = 7e-9` m (minimum gate length)
- `nfin = 14` (matched sizing — symmetric inverter)
- Note: PMOS carries ~78% of NMOS drive strength due to µp < µn; matched nfin implies the PMOS will be the speed-limiting device in the pull-up network.

---

## SPICE Files

### `inverter_vtc.spice` — Full Characterization Deck

This is the primary analysis file. It performs **both DC and transient analyses sequentially** within a single `.control` block, extracting a comprehensive set of figures of merit.

#### DC Analysis Block

```spice
.dc v1 0 0.7 1m
```

Sweeps the input voltage from **0 V → 0.7 V** in **1 mV steps** with `V2` (VDD) held at 0.7 V.

**Measurements performed:**

```spice
meas dc v_th when nfet_out = nfet_in
```
Switching threshold V_th — the input voltage at which Vout = Vin (unity-gain crossing on the VTC). For a symmetric inverter, V_th ≈ VDD/2 = 0.35 V.

```spice
let gain_av = abs(deriv(nfet_out))
meas dc max_gain max gain_av
```
Peak voltage gain magnitude |Av|_max = |dVout/dVin|_max, occurring at V_th. For a well-designed inverter at 7nm, peak gain of 10–30 V/V is typical.

```spice
meas dc vil find nfet_in when gain_av = gain_target cross=1
meas dc vih find nfet_in when gain_av = gain_target cross=2
meas dc voh find nfet_out when gain_av = gain_target cross=1
meas dc vol find nfet_out when gain_av = gain_target cross=2
```
Noise margin boundary voltages (unity-gain points method):
- **V_IL:** Maximum input voltage still interpreted as logic LOW
- **V_IH:** Minimum input voltage interpreted as logic HIGH
- **V_OH:** Output voltage when input = V_IL (pull-up output high level)
- **V_OL:** Output voltage when input = V_IH (pull-down output low level)

**Noise margin computation:**
```spice
let nmh = voh - vih    ; Noise Margin HIGH = VOH − VIH
let nml = vil - vol    ; Noise Margin LOW  = VIL − VOL
```

**Transconductance and output resistance:**
```spice
let id   = v2#branch                       ; Total supply current
let gm   = real(deriv(id, nfet_in))        ; gm = dId/dVin
let r_out = deriv(nfet_out, id)            ; Rout = dVout/dId
```

#### Transient Analysis Block

```spice
.tran 1e-12 100e-12
```
Time step: **1 ps**, stop time: **100 ps**. Input stimulus `V1` generates a pulse:

```spice
V1 nfet_in GND pulse(0 0.7 20p 10p 10p 20p 500p 1)
*                      |   |  |   |   |   |   |   └─ cycles
*                      LO  HI del  tr  tf  pw  per
```
- Delay: 20 ps, Rise time: 10 ps, Fall time: 10 ps
- Pulse width: 20 ps, Period: **500 ps** (2 GHz input frequency)

**Propagation delay measurements:**
```spice
meas tran tpr when nfet_in  = 0.35 rise=1   ; 50% crossing on rising input
meas tran tpf when nfet_out = 0.35 fall=1   ; 50% crossing on falling output
let tp = (tpr + tpf) / 2                    ; Average propagation delay
```

**Dynamic power estimation:**
```spice
meas tran id_pwr integ trans_current from=2e-11 to=6e-11
let pwr  = id_pwr * 0.7      ; P = Q × V (charge × VDD)
let power = abs(pwr / 40e-12) ; Average over 40 ps switching window
```

**Rise/fall time characterization (10%–90% method):**
```spice
.tran 0.1 100p
meas tran tr when nfet_in  = 0.07 RISE=1    ; 10% of VDD on input rising
meas tran tf when nfet_out = 0.63 FALL=1    ; 90% of VDD on output falling
let t_delay = tr + tf
let f = 1 / t_delay                          ; Maximum toggle frequency estimate
```

---

### `inverter_finfet.spice` — Transient-Only Deck

A lighter-weight deck for pure waveform inspection:

```spice
.tran 0.1p 100p
```

Step: **0.1 ps**, Stop: **100 ps**. Plots `nfet_out` and `nfet_in` together for visual rise/fall inspection. No measurement commands — intended for waveform shape verification before running the full characterization deck.

---

## Expected Performance Targets (7nm, nfin=14, VDD=0.7V)

| Metric | Expected Range | Notes |
|---|---|---|
| Switching Threshold V_th | ~0.33–0.37 V | Near VDD/2 for matched nfin |
| Peak Voltage Gain |Av| | 10–30 V/V | Higher gain → sharper VTC |
| Noise Margin HIGH (NMH) | 0.12–0.20 V | VOH − VIH |
| Noise Margin LOW (NML) | 0.12–0.20 V | VIL − VOL |
| Propagation Delay t_p | 5–25 ps | Unloaded, min-size inverter |
| Rise Time (10–90%) | 10–30 ps | PMOS limited |
| Fall Time (10–90%) | 8–20 ps | NMOS limited |
| Dynamic Power (@ 2 GHz) | 10–50 µW | α·C·VDD²·f, parasitic-dependent |

---

## Running the Simulations

```bash
# Full characterization (DC + transient, measurements printed to stdout)
ngspice -b inverter_vtc.spice

# Transient waveform only (interactive plot window)
ngspice inverter_finfet.spice
```

Output will print extracted values for `v_th`, `max_gain`, `vil`, `vih`, `voh`, `vol`, `nmh`, `nml`, `tpr`, `tpf`, `tp`, `power`, and `f` to the console.

---

## Simulation Waveforms & Plots

> **Placeholder section.** Execute the `.spice` decks, capture PNG waveform exports, and insert at the image paths below.

### Voltage Transfer Characteristic (VTC)

![Inverter VTC — Vout vs Vin DC Sweep](./images/inverter_vtc.png)

*Expected: Classic CMOS inverter S-curve. X-axis: Vin = 0 → 0.7 V. Y-axis: Vout = 0.7 V → 0 V. Switching threshold V_th visible as the midpoint crossing. Steep transition region indicates high voltage gain.*

---

### Noise Margin Extraction — Unity-Gain Points

![Noise Margin Extraction — VTC with NMH and NML Annotated](./images/inverter_noise_margins.png)

*Expected: VTC overlaid with the derivative |dVout/dVin|. Unity-gain crossings mark VIL and VIH. Hatched rectangles represent NMH (upper right) and NML (lower left) graphically.*

---

### Peak Voltage Gain |dVout/dVin|

![Inverter Peak Gain vs Input Voltage](./images/inverter_gain_curve.png)

*Expected: |Av| plotted vs Vin. Peak gain occurs at Vin = V_th. Gain collapses to ~0 in the deep triode (Vin → 0) and saturation (Vin → VDD) regions.*

---

### Transient Input/Output Waveforms (500 ps Period Pulse)

![Inverter Transient Waveforms — Vin and Vout vs Time](./images/inverter_transient.png)

*Expected: Two overlaid waveforms. Input pulse (0 → 0.7 V) and inverted output (0.7 V → 0 V). Rise/fall propagation delay visible as the time offset between 50% crossings. Note asymmetry between pull-up (PMOS, slower) and pull-down (NMOS, faster) transitions.*

---

### Propagation Delay Measurement Detail

![Propagation Delay — 50% Crossing Zoom](./images/inverter_prop_delay.png)

*Expected: Zoomed view of the 50% crossing points. Cursors mark t_pLH (rising output) and t_pHL (falling output). Average delay t_p = (t_pLH + t_pHL) / 2 annotated.*

---

### Supply Current Transient (Dynamic Power)

![Supply Current vs Time During Switching](./images/inverter_supply_current.png)

*Expected: V2#branch current plotted vs time. Switching spikes visible at each transition edge. The integral of current over a switching window, multiplied by VDD, gives switching energy per cycle.*

---

## Extracted Metrics Summary

> Populate after simulation runs.

| Metric | Measured Value | Unit |
|---|---|---|
| V_th (switching threshold) | — | V |
| Peak Gain |Av|_max | — | V/V |
| V_IL | — | V |
| V_IH | — | V |
| V_OH | — | V |
| V_OL | — | V |
| NMH = VOH − VIH | — | V |
| NML = VIL − VOL | — | V |
| t_pLH (50%) | — | ps |
| t_pHL (50%) | — | ps |
| t_p (average) | — | ps |
| Rise Time (10%–90%) | — | ps |
| Fall Time (10%–90%) | — | ps |
| Max Toggle Frequency | — | GHz |
| Dynamic Power | — | µW |
