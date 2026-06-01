# SKY130 PDK — Comprehensive Reference Guide

**Archives Covered**

| Archive | Version | Extracted Size |
|---|---|---|
| `sky130_die_collateral_1_1.tgz` | 1.1 | ~1.1 MB |
| `sky130_release_0_1_0.tgz` | 0.1.0 | ~167 MB |
| `sky130_scl_9T_0_1_1.tgz` | 0.1.1 | ~122 MB |

**Toolchain:** Cadence Virtuoso / Pegasus / Quantus / Innovus  
**Process:** SkyWater 130 nm (sky130), 1.8 V nominal

---

## Table of Contents

1. [Overview & Context](#1-overview--context)
2. [Archive 1 — sky130_die_collateral 1.1](#2-archive-1--sky130_die_collateral-11)
3. [Archive 2 — sky130_release 0.1.0](#3-archive-2--sky130_release-010)
   - 3.1 [Top-level layout](#31-top-level-layout)
   - 3.2 [Primitive device library (sky130_fd_pr_main)](#32-primitive-device-library-sky130_fd_pr_main)
   - 3.3 [Flat cells/ directory](#33-flat-cells-directory)
   - 3.4 [SPICE Models hierarchy](#34-spice-models-hierarchy)
   - 3.5 [Physical Verification (DRC / LVS)](#35-physical-verification-drc--lvs)
   - 3.6 [Metal Fill (FILLGEN)](#36-metal-fill-fillgen)
   - 3.7 [Quantus Extraction](#37-quantus-extraction)
4. [Archive 3 — sky130_scl_9T 0.1.1](#4-archive-3--sky130_scl_9t-011)
   - 4.1 [Library variants](#41-library-variants)
   - 4.2 [Technology files (sky130_scl_9T_tech)](#42-technology-files-sky130_scl_9t_tech)
   - 4.3 [Deliverable formats per variant](#43-deliverable-formats-per-variant)
   - 4.4 [Complete cell catalog](#44-complete-cell-catalog)
   - 4.5 [Liberty timing corners](#45-liberty-timing-corners)
   - 4.6 [Layer stack key parameters](#46-layer-stack-key-parameters)
5. [Cross-Package Integration Notes](#5-cross-package-integration-notes)
6. [Common Issues & Tips](#6-common-issues--tips)

---

## 1. Overview & Context

This is the **Cadence-packaged** version of the SkyWater 130 nm open-source PDK, set up for a Virtuoso-centric digital and mixed-signal design flow. It is distinct from the raw open-source sky130 GitHub distribution in that it ships as a ready-to-use Cadence library (`cds.lib`, `cdsinfo.tag`, `.oalib`, OA databases) alongside the standard file formats (GDSII, OASIS, LEF, Liberty, CDL, DSPF, Spectre).

The three archives represent three distinct layers of the design kit:

- **die_collateral** → physical die-prep deliverables for MPW shuttle submission
- **sky130_release** → the core PDK: primitive devices, SPICE models, DRC/LVS rules
- **sky130_scl_9T** → the standard cell library for digital place-and-route

---

## 2. Archive 1 — sky130_die_collateral 1.1

**Root:** `sky130_die_collateral_1.1/`

### Purpose
Contains all geometry required to complete a die for a Multi-Project Wafer (MPW) tapeout. Cadence assigns an 8-character die ID (e.g. `2506ABCD` = year 25, month 06, batch ABCD). The customer must integrate these pieces at the chip top level before submission.

### Directory layout
```
sky130_die_collateral_1.1/
├── README                          ← Die prep guidelines (read this first!)
├── sky130_die_collateral.gds       ← All collateral in GDSII format
├── sky130_die_collateral.oas       ← All collateral in OASIS format
└── sky130_die_collateral/          ← Virtuoso (OpenAccess) library
    ├── cdsinfo.tag
    ├── data.dm
    ├── .oalib
    ├── sealring_3600x5200/layout/  ← The die boundary seal ring
    ├── mpw_dieid_2506ABCD_example/ ← Die ID block only (example)
    ├── mpw_sealring_dieid_2506ABCD_example/ ← Top-level example (sealring + ID)
    ├── pg_text_0/ … pg_text_9/     ← Digit glyphs 0–9
    ├── pg_text_A/ … pg_text_Z/     ← Letter glyphs A–Z
    └── pg_text_all/                ← All glyphs in one cell
```
Each cell contains: `layout/layout.oa`, `layout/master.tag`, `layout/thumbnail_128x128.png`

### Key die-prep rules (from README)
- Seal ring bounding box: **3.6 mm × 5.2 mm**; must be placed at **(0, 0)** in the top-level hierarchy
- Die ID block placement: **(180, 52)** (in µm, within the seal ring)
- Top-level cell name: `<designName>_<dieID>` (e.g. `cadencechip_2506ABCD`)
- Submission file: OASIS compressed with gzip, named `<designName>_<dieID>.oas.gz`

### Version delta (1.0 → 1.1)
Fill blockage layers in `mpw_dieid_2506ABCD_example` were updated from `cmmX waffleDrop` to `metX fill_block` on all metal layers (met1–met5).

### How to use
- In Virtuoso: add `sky130_die_collateral` to your `cds.lib`, then instantiate `mpw_sealring_dieid_2506ABCD_example` as a reference for your own top-level.
- In a GDS/OAS flow: stream in `sky130_die_collateral.gds` (or `.oas`) and reference the cells by name.

---

## 3. Archive 2 — sky130_release 0.1.0

**Root:** `sky130_release_0.1.0/`

### 3.1 Top-level layout

```
sky130_release_0.1.0/
├── cds.lib              ← Library pointers (analogLib, basic, sky130_fd_pr_main)
├── CDS.log              ← Cadence session log
├── .oalib
├── .cadence/            ← Cadence tool config (jobpolicy, perf)
├── pv/                  ← Physical verification presets & rule pointers
├── libs/                ← OA library: sky130_fd_pr_main
├── cells/               ← 125 per-cell flat SPICE/CDL directories
├── models/              ← SPICE model hierarchy
├── Sky130_DRC/          ← Pegasus DRC deck + docs
├── Sky130_LVS/          ← Pegasus LVS deck + docs
├── Sky130_FILLGEN/      ← Metal fill generation rules + docs
├── quantus/             ← Quantus RC extraction setup
└── doc/REVISION         ← Release notes
```

### 3.2 Primitive device library (sky130_fd_pr_main)

**Path:** `libs/sky130_fd_pr_main/`  
This is a Virtuoso OpenAccess library. Each cell has views: `layout`, `symbol`, `schematic` (where applicable), `auCdl`, `auLvs`, `spectre`, and `ivpcell`.

**Device catalog**

| Category | Cells |
|---|---|
| **Logic-voltage NFETs (1.8 V)** | `nfet_01v8`, `nfet_01v8_lvt` |
| **Native/medium-voltage NFETs** | `nfet_03v3_nvt`, `nfet_05v0_nvt` |
| **High-voltage NFETs (20 V)** | `nfet_20v0`, `nfet_20v0_zvt`, `nfet_g5v0d10v5`, `nfet_g5v0d16v0` |
| **20 V isolated variants** | `nfet_20v0_iso`, `nfet_20v0_nvt`, `nfet_20v0_nvt_iso`, `nfet_20v0_reverse_iso`, `nfet_20v0_nvt` |
| **Logic-voltage PFETs (1.8 V)** | `pfet_01v8`, `pfet_01v8_hvt`, `pfet_01v8_lvt`, `pfet_01v8_mvt` |
| **High-voltage PFETs** | `pfet_20v0`, `pfet_g5v0d10v5`, `pfet_g5v0d16v0` |
| **RF NFETs** | `rf_nfet_01v8`, `rf_nfet_01v8_lvt`, `rf_nfet_20v0_*` (7 variants) |
| **RF PFETs** | `rf_pfet_01v8`, `rf_pfet_01v8_lvt`, `rf_pfet_01v8_mvt`, `rf_pfet_20v0_withptap` |
| **BJTs** | `npn_05v5`, `npn_11v0`, `pnp_05v5` |
| **RF BJT** | `rf_npn_05v5` |
| **ESD NFETs** | `esd_nfet_01v8`, `esd_nfet_05v0_nvt`, `esd_nfet_g5v0d10v5` |
| **ESD PFETs** | `esd_pfet_g5v0d10v5` |
| **ESD RF diodes** | `esd_rf_diode_pd2nw_11v0`, `esd_rf_diode_pw2nd_11v0` |
| **ESD RF NFETs (HBM/IEC)** | `esd_rf_nfet_20v0_hbm`, `esd_rf_nfet_20v0_iec` |
| **Diodes (5.5 V)** | `diode_pd2nw_05v5`, `diode_pd2nw_05v5_hvt`, `diode_pd2nw_05v5_lvt` |
| **Diodes (11 V)** | `diode_pd2nw_11v0`, `diode_pw2nd_05v5`, `diode_pw2nd_05v5_lvt`, `diode_pw2nd_05v5_nvt`, `diode_pw2nd_11v0` |
| **VPP Capacitors** | 30+ `cap_vpp_*` variants (various sizes, layer stacks, shielding configs) |
| **MIM Capacitor** | `cap_mim_m3__base` |
| **Variable Capacitors** | `cap_var_hvt`, `cap_var_lvt` |
| **Poly resistors (high-R)** | `res_high_po_0p35/0p69/1p41/2p85/5p73` |
| **Poly resistors (extra-high-R)** | `res_xhigh_po_0p35/0p69/1p41/2p85/5p73` |
| **Metal/diffusion resistors** | `res_generic_m1/m2/m3/m4/m5/nd/pd` |
| **Isolated PW resistor** | `res_iso_pw` |
| **Inductors** | `ind_03`, `ind_05` |
| **RF test coils** | `rf_test_coil1/2/3` |
| **Special cells** | `nwellTap`, `subTap`, `polyConn`, `diffConn`, `nwdiode_top` |
| **Special NFETs** | `special_nfet_latch`, `special_nfet_pass`, `special_nfet_pass_flash`, `special_nfet_pass_lvt`, `special_pfet_pass` |
| **RF AURA** | `rf_aura_blocking`, `rf_aura_drc_flag_check`, `rf_aura_lvs_drc` |

Also in the library root:
- `tech.db`, `techfile.tf` → Virtuoso technology database
- `display.drf` → Display resource file (layer colors)
- `sky130_fd_pr_main.layermap` → Stream layer map (GDSII layer numbers)
- `libInit.il`, `libInitCktPro.il`, `libInitCustomExit.il`, `loadCxt.ile` → Library init SKILL scripts
- `pdkUtils.cxt`, `pdkUtils64bit.cxt`, `sky130_fd_pr_main64bit.cxt` → Compiled context files
- `.Cat` catalog files: `bip.Cat`, `cap.Cat`, `customVias.Cat`, `diffusion.Cat`, `diode.Cat`, `P#2b/2dPrecision.Cat`

### 3.3 Flat cells/ directory

**Path:** `cells/`  
Contains **125 cells**, each in its own subdirectory with flat per-instance SPICE files. This is the format used for direct simulation without the Virtuoso library.

**Cell naming convention:** `sky130_fd_pr__<cellname>__<corner>.spice`

Each cell directory (example: `cells/nfet_01v8/`) contains:
- `*__tt.corner.spice` — Typical SPICE model (TT corner)
- `*__ff.corner.spice` — Fast-Fast corner
- `*__ss.corner.spice` — Slow-Slow corner
- `*__fs.corner.spice` — Fast-N / Slow-P corner
- `*__sf.corner.spice` — Slow-N / Fast-P corner
- `*__leak.corner.spice` — Leakage corner
- `*__wafer.corner.spice` — Wafer-level corner
- `*__tt_leak.corner.spice` — TT + leakage combined
- `*__tt_correln.corner.spice` — N-FET correlation corner
- `*__tt_correlp.corner.spice` — P-FET correlation corner
- `*__mismatch.corner.spice` — Mismatch model
- `*__subvt_mismatch.corner.spice` — Sub-threshold mismatch
- `*.pm3.spice` + `*__<corner>.pm3.spice` — PSP/BSIM model parameter set (large files, 1+ MB each)
- `*.bins.csv` — Binning table (W/L vs bin assignment)
- `*_aM<n>W<w>L<l>.cdl` — Pre-sized CDL netlists (M=fingers, W=width, L=length)
- `*.netlist.tsv` — Tab-separated netlist description

**Special cells in cells/ not in libs/:** `cap_var_hvt`, `cap_var_lvt`, `cap_vpp_01p8x01p8_m1m2_noshield`, `cap_vpp_03p9x03p9_m1m2_shieldl1_floatm3`, `cap_vpp_11p3x11p8_l1m1m2m3m4_shieldm5` (plus the full polycap series), `esd_*` devices, `ind_03/05`, `nfet_20v0_iso` variants, `rf_*` cells, `res_iso_pw`, `special_*`

### 3.4 SPICE Models hierarchy

**Path:** `models/`

```
models/
├── sky130.lib.spice         ← Master model file (includes all sub-files)
├── all.spice                ← Alternate all-in-one include
├── head.spice               ← Header (.lib section stubs)
├── custom.spice             ← Placeholder for user customization
│
├── corners/                 ← Corner model files
│   ├── tt.spice             ← Typical-Typical
│   ├── ff.spice             ← Fast-Fast
│   ├── ss.spice             ← Slow-Slow
│   ├── fs.spice             ← Fast-N/Slow-P
│   ├── sf.spice             ← Slow-N/Fast-P
│   ├── leak.spice           ← Leakage (low-VT for worst-case Iddq)
│   ├── wafer.spice          ← Wafer-probe corner
│   └── {corner}/            ← Subdirs with expanded corner parameter sets
│
├── continuous/              ← Device-type separated models (good for AMS sim)
│   ├── sky130.lib.spice     ← Continuous lib (includes below)
│   ├── models_fet.spice     ← All FET models (~2 MB)
│   ├── models_bjt.spice
│   ├── models_capacitors.spice
│   ├── models_diodes.spice
│   ├── models_resistors.spice
│   ├── models_global.spice  ← Global parameters
│   └── parameters_fet_{tt/ff/ss/fs/sf}.spice  ← Per-corner parameters
│
├── parameters/              ← Full parameter extraction sets
│   ├── typical.spice        ← TT parameters
│   ├── fast.spice           ← FF parameters
│   ├── slow.spice           ← SS parameters
│   ├── fast_70p.spice       ← FF at 70th percentile
│   ├── slow_70p.spice       ← SS at 70th percentile
│   ├── montecarlo.spice     ← Monte Carlo parameter set (~1.3 MB)
│   ├── invariant.spice      ← Process-invariant parameters
│   ├── critical.spice       ← Critical parameters
│   └── lod.spice            ← Length-of-diffusion parameters
│
├── capacitors/              ← Dedicated cap models
│   ├── sky130_fd_pr__model__cap_mim.model.spice
│   ├── sky130_fd_pr__model__cap_var.model.spice
│   ├── sky130_fd_pr__model__cap_vpp.model.spice
│   ├── sky130_fd_pr__model__cap_vpp_only_mos.model.spice
│   ├── sky130_fd_pr__model__cap_vpp_only_p.model.spice
│   └── sky130_fd_pr__model__cap_vpp_only_pq.model.spice
│
├── parasitics/              ← Parasitic diode/resistor models (11 files)
│   └── sky130_fd_pr__model__parasitic__*.model.spice
│
├── r+c/                     ← Combined R and C corner models (6 combos × lin/nonlin)
│   ├── res_high__cap_high.spice  (and __lin variants)
│   ├── res_high__cap_low.spice
│   ├── res_low__cap_high.spice
│   ├── res_low__cap_low.spice
│   └── res_typical__cap_typical.spice
│
├── correl1.spice … correl4.spice  ← N-P correlation models
├── r+c.mrp1monte.spice            ← R+C Monte Carlo
│
├── sky130_fd_pr__model__diode_pd2nw_11v0.model.spice
├── sky130_fd_pr__model__diode_pw2nd_11v0.model.spice
├── sky130_fd_pr__model__inductors.model.spice
├── sky130_fd_pr__model__linear.model.spice
├── sky130_fd_pr__model__pnp.model.spice
├── sky130_fd_pr__model__r+c.model.spice
│
└── sonos*/                  ← SONOS non-volatile memory models
    ├── sonos/               ← Standard SONOS: begin_of_life, end_of_life
    ├── sonos_e/             ← SONOS enhanced: + .bins.csv, .pm3.spice
    ├── sonos_p/             ← SONOS program: + .bins.csv, .pm3.spice
    ├── sonos_see/           ← SONOS SEE (single-electron erase)
    ├── sonos_see_e/         ← SONOS SEE enhanced
    └── sonos_see_p/         ← SONOS SEE program
```

**How to invoke models in simulation**

For Spectre/SpectreAPS:
```
include "sky130_release_0.1.0/models/sky130.lib.spice" section=tt
```
For ngspice / Xyce:
```spice
.lib "models/sky130.lib.spice" tt
```
Available sections: `tt`, `ff`, `ss`, `fs`, `sf`, `leak`, `wafer`, `mc` (Monte Carlo)

**nfet_01v8 SPICE call format (from CDL examples):**
```spice
Mmn0 drain gate source bulk nfet_01v8 W=420n L=150n M=1
```

### 3.5 Physical Verification (DRC / LVS)

#### pv/ directory (Pegasus presets)
```
pv/
├── techRuleSets     ← Maps ruleset names to DRC/LVS .pvl files
├── drc.preset       ← DRC UI preset file
├── lvs.preset       ← LVS UI preset file
├── lvs_qrc.preset   ← LVS + QRC extraction preset
└── extview.trp      ← Extracted view trip-point config
```
The `techRuleSets` file defines two rulesets: `default` (DRC+LVS) and `lvs_qrc`.

#### Sky130_DRC/
- **Primary file:** `sky130_rev_0.0_2.12.drc.pvl` (26 KB, Pegasus PVL format)
- **Data integrity check:** `sky130_data_integrity.v002.pvl`
- **Configurator:** `sky130.drc.cfg` (enable/disable rule groups)
- **Documentation:** `SKY130_DRC_User_Guide_July_22-2025.pdf`, `Sky130_DRM_July_22_2025.pdf`

Setup: Set `PEGASUS_DRC` env var to this directory before starting Virtuoso.

Notable feature: "Alternate SRAM Rules" switch in configurator (`licon.4a/4b`, `mcon.cover.1`) — for SRAM debug only, not for full tapeout.

#### Sky130_LVS/
- **Primary file:** `sky130.lvs.v0.0_1.1.pvl` (64 KB)
- **Reference CDL:** `source.cdl`
- **VPP cap fixes:** `cap_vpp_fixes.tar.gz` — must be untarred inside `libs/sky130_fd_pr_main/`
- **Documentation:** `Sky130_PDK_Changes_for_LVS.pdf`

**Known CDF changes required for LVS:**
1. **VPP caps** → `auCdl` namePrefix must be `"X"`; some need `top` pin added to layout
2. **Diodes** → change `auCdl` netlistProcedure from `ansCdlCompPrim` to `ansCdlSubcktCallExtended`
3. **BJTs** → same procedure change; `modelName` must match cellName; `componentName` empty
4. **HV MOSFETs** (nfet_20v0, nfet_20v0_zvt, pfet_20v0) → same procedure change; add `nf` to CDL parameters

### 3.6 Metal Fill (FILLGEN)

**Path:** `Sky130_FILLGEN/`
- **Rules file:** `fillgen.v08.pvl` (77 KB, Pegasus PVL)
- **Documentation:** `SKY130_FILLGEN_User_Guide_v08.pdf`
- **GDS_flow/** — Scripts/config for GDSII-based fill insertion
- **Oasis_flow/** — Scripts/config for OASIS-based fill insertion

### 3.7 Quantus Extraction

**Path:** `quantus/extraction/typical/`  
Pre-configured for typical-corner RC extraction. The `extview.trp` in `pv/` ties Quantus to the Virtuoso Extracted View (EXV) and Smart View (SMV) features.

---

## 4. Archive 3 — sky130_scl_9T 0.1.1

**Root:** `sky130_scl_9T_0.1.1/`  
A 9-track-height standard cell library for digital place-and-route, characterized with Cadence Liberate.

### 4.1 Library variants

```
sky130_scl_9T_0.1.1/
├── sky130_scl_9T/         ← Base variant (nominal VT)
├── sky130_scl_9T_HS/      ← High Speed (optimized for performance, lower VT)
├── sky130_scl_9T_LP/      ← Low Power (HVT PMOS, reduced leakage)
└── sky130_scl_9T_tech/    ← Shared technology files
```

| Variant | Abbrev | Optimization | PMOS Vt | Use when |
|---|---|---|---|---|
| `sky130_scl_9T` | base | Balanced | Nominal | General purpose |
| `sky130_scl_9T_HS` | HS | Speed | Low | Timing-critical paths |
| `sky130_scl_9T_LP` | LP | Leakage | High (HVT) | Power-critical designs |

### 4.2 Technology files (sky130_scl_9T_tech)

```
sky130_scl_9T_tech/
├── lef/
│   ├── sky130_scl_9T.tlef         ← Technology LEF (layers, vias, sites)
│   └── sky130_scl_9T_phyCells.lef ← Physical cells (filler, decap, tap, tie, endcap)
├── lib/
│   └── sky130_scl_9T_phyCells.lib ← Liberty for physical cells (TIEHI, TIELO)
└── gds/
    └── sky130_scl_9T_tech.gds     ← Technology GDS (power stripes, boundary cells)
```

### 4.3 Deliverable formats per variant

Each variant directory (`sky130_scl_9T`, `_HS`, `_LP`) contains these subdirectories:

| Directory | Files | Description |
|---|---|---|
| `lib/` | 3 `.lib.gz` files | Liberty NLDM timing at 3 corners (gzip compressed) |
| `lef/` | 1 `.lef` | Abstract cell LEF for all cells (place-and-route physical) |
| `gds/` | 1 `.gds` | GDSII with all cell layouts |
| `cdl/` | 1 `.cdl` | CDL (SPICE) netlist for all cells (LVS reference) |
| `verilog/` | 1 `.v` | Verilog behavioral+timing model (SDF-annotatable) |
| `spectre/` | 1 `.scs` | Spectre simulation netlist |
| `dspf/` | 106 `.spf` files | Per-cell DSPF (Quantus RC parasitics, TT 25°C) |
| `oa/` | OA library | OpenAccess views: layout, schematic, symbol, abstract |
| `pgv/` | PG views | Power-ground via files (base and HS only; LP lacks pgv/) |

**DSPF note:** Extracted by Cadence Quantus 22.1.0-p089, TT corner, 25°C. DSPF version 1.5, device finger delimiter `@`, bus bit chars `[]`.

### 4.4 Complete cell catalog

**106 cells total** (naming convention: `<FUNCTION><INPUTS>X<DRIVE>_<VARIANT>`)

| Function | Cells |
|---|---|
| **Full adder** | `ADDFX1` |
| **Half adder** | `ADDHX1` |
| **AND** | `AND2X1`, `AND2X2`, `AND3X1`, `AND3X2`, `AND4X1`, `AND4X2` |
| **NAND** | `NAND2X1/X2/X4`, `NAND3X1/X2/X4`, `NAND4X1/X2/X4` |
| **OR** | `OR2X1`, `OR2X2`, `OR3X1`, `OR3X2`, `OR4X1`, `OR4X2` |
| **NOR** | `NOR2X1/X2/X4`, `NOR3X1/X2/X4`, `NOR4X1/X2/X4` |
| **AOI (AND-OR-INVERT)** | `AOI21X1/X2`, `AOI22X1/X2`, `AOI211X1/X2`, `AOI221X1/X2`, `AOI222X1/X2` |
| **OAI (OR-AND-INVERT)** | `OAI21X1/X2`, `OAI22X1/X2`, `OAI211X1/X2`, `OAI221X1/X2`, `OAI222X1/X2` |
| **XOR** | `XOR2X1/X2/X4` |
| **XNOR** | `XNOR2X1/X2/X4` |
| **MUX 2:1** | `MX2X1`, `MX2X4` |
| **MUX 4:1** | `MX4X1`, `MX4X4` |
| **Inverter** | `INVX1/X2/X4/X8/X16` |
| **Buffer** | `BUFX2/X4/X8/X16` |
| **Clock inverter** | `CLKINVX1/X2/X4/X8` |
| **Clock buffer** | `CLKBUFX2/X4/X8` |
| **Clock AND** | `CLKAND2X2` |
| **Clock MUX** | `CLKMX2X2` |
| **Clock XOR** | `CLKXOR2X1` |
| **Tri-state buffer** | `TBUFX1/X4/X8` |
| **D flip-flop** | `DFFX1/X4` |
| **DFF with reset** | `DFFRX1/X4` |
| **DFF with set** | `DFFSX1/X4` |
| **DFF with set+reset** | `DFFSRX1/X4` |
| **Scan DFF** | `SDFFX1/X4` |
| **Scan DFF + reset** | `SDFFRX1/X4` |
| **Scan DFF + set** | `SDFFSX1/X4` |
| **Scan DFF + set+reset** | `SDFFSRX1/X4` |
| **Transparent latch** | `TLATX1` |
| **Transparent latch + set+reset** | `TLATSR X1` |
| **Delay cells** | `DLY1X1/X4`, `DLY2X4`, `DLY4X4` |

**Physical/tech cells** (in `sky130_scl_9T_tech`): `TIEHI`, `TIELO` (and filler/decap/tap referenced in LEF)

### 4.5 Liberty timing corners

Liberty files generated by **Cadence Liberate 24.1.0.930**, March 4, 2025.

| Corner file | Voltage | Temperature | Use |
|---|---|---|---|
| `sky130_tt_1.8_25_nldm.lib.gz` | 1.8 V | 25 °C | Synthesis, nominal STA |
| `sky130_ff_1.98_0_nldm.lib.gz` | 1.98 V | 0 °C | Best-case hold check |
| `sky130_ss_1.62_125_nldm.lib.gz` | 1.62 V | 125 °C | Worst-case setup check |

Table format: NLDM (Non-Linear Delay Model), 7×8 lookup tables.  
Units: time in ns, capacitance in pF, current in mA, power in nW, resistance in kΩ.

### 4.6 Layer stack key parameters (from sky130_scl_9T.tlef)

| Layer | Type | Direction | Min Width | Pitch | Sheet Resistance | DC Current Density |
|---|---|---|---|---|---|---|
| `met1` | Routing | Horizontal | 0.14 µm | 0.46 µm | 125 mΩ/□ | 2.8 mA/µm |
| `met2` | Routing | Vertical | 0.14 µm | 0.46 µm | 125 mΩ/□ | 2.8 mA/µm |
| `met3` | Routing | Horizontal | 0.30 µm | 0.69 µm | 47 mΩ/□ | 6.8 mA/µm |
| `met4` | Routing | Vertical | 0.30 µm | 0.69 µm | 47 mΩ/□ | 6.8 mA/µm |
| `met5` | Routing | Horizontal | 1.60 µm | 3.22 µm | 29 mΩ/□ | 10.17 mA/µm |
| `via` (M1M2) | Cut | — | 0.15 µm | — | — | 0.29 mA/via |
| `via2` (M2M3) | Cut | — | 0.20 µm | — | — | 0.48 mA/via |
| `via3` (M3M4) | Cut | — | 0.20 µm | — | — | 0.48 mA/via |
| `via4` (M4M5) | Cut | — | 0.80 µm | — | — | 2.49 mA/via |

**li1 (local interconnect):** Defined but commented out as a routing layer; treated as MASTERSLICE (non-routing) for tool compatibility.

**Core site:** 0.46 µm × 4.14 µm (9 tracks, X-Y symmetric)  
**Manufacturing grid:** 5 nm  
**ADDFX1 cell size (example):** 8.28 µm × 4.14 µm (18 × 1 sites)

**Via rules defined:** M1M2_PR, M2M3_PR, M3M4_PR, M4M5_PR (each with 4 orientations: PR, PR_R, PR_M, PR_MR, PR_C)

---

## 5. Cross-Package Integration Notes

### Using the release with the SCL

The `sky130_release_0.1.0/cds.lib` only points to `libs/sky130_fd_pr_main`. For a mixed-signal or full-chip flow add the SCL OA library to `cds.lib`:
```
DEFINE sky130_scl_9T_LP  /path/to/sky130_scl_9T_0.1.1/sky130_scl_9T_LP/oa/sky130_scl_9T_LP
```

### Connecting PV to the SCL

- LEF for P&R: `sky130_scl_9T_tech/lef/sky130_scl_9T.tlef` + `sky130_scl_9T_LP/lef/sky130_scl_9T_LP.lef`
- LVS reference CDL: `sky130_scl_9T_LP/cdl/sky130_scl_9T_LP.cdl`
- DSPF for post-layout STA: `sky130_scl_9T_LP/dspf/<CELL>_LP.spf`
- LVS rule deck: `sky130_release_0.1.0/Sky130_LVS/sky130.lvs.v0.0_1.1.pvl`

### Die collateral in a full-chip tapeout
1. Complete P&R using SCL LEF + tech LEF
2. Add the primitive devices using `sky130_fd_pr_main` in Virtuoso
3. Stream out top-level OASIS (or GDS)
4. Merge die collateral: instantiate `sealring_3600x5200` at (0,0) and `mpw_dieid_<ID>` at (180,52)
5. Rename top-level cell to `<designName>_<dieID>`
6. Submit as `<designName>_<dieID>.oas.gz`

### Model-to-cell cross-reference

| Verilog/Liberty cell | CDL primitive FET | Model to use |
|---|---|---|
| `INVX1` (LP variant) | `pfet_01v8_hvt` (P), `nfet_01v8` (N) | `models/sky130.lib.spice`, section `tt` |
| `INVX1` (HS variant) | `pfet_01v8_lvt` (P), `nfet_01v8_lvt` (N) | same |
| Analog custom | `pfet_01v8`, `nfet_01v8` | `cells/nfet_01v8/*.corner.spice` |

---

## 6. Common Issues & Tips

### LVS failures on VPP caps
Apply `cap_vpp_fixes.tar.gz` from `Sky130_LVS/` inside the `libs/sky130_fd_pr_main/` directory:
```bash
cd sky130_release_0.1.0/libs/sky130_fd_pr_main
tar -xf ../../Sky130_LVS/cap_vpp_fixes.tar.gz
```
Then update CDF: `auCdl` → namePrefix = `"X"` for all VPP cap cells.

### LVS failures on diodes
Change `auCdl` → `netlistProcedure` from `ansCdlCompPrim` to `ansCdlSubcktCallExtended`. Diodes netlist as a subcircuit call with area/perimeter args: `DD0 anode cathode diode_pd2nw_05v5 0.36 2.4 m=1`.

### LVS failures on BJTs / HV MOSFETs
Same `netlistProcedure` change. For `npn_*` / `pnp_*`: `modelName` must exactly match the cellName, `componentName` must be empty. For `nfet_20v0`, `nfet_20v0_zvt`, `pfet_20v0`: add `nf` to the CDL parameter list.

### DRC rule groups and SRAM
The "Alternate SRAM Rules" switch is for debug only — do NOT use for final tapeout as it relaxes constraints and may miss real violations.

### Liberty files are gzipped
Unzip before feeding to EDA tools that do not auto-detect gzip:
```bash
gunzip sky130_scl_9T_LP/lib/*.lib.gz
```

### li1 is not a routing layer
The `sky130_scl_9T.tlef` explicitly comments out li1 as a routing layer. Do not enable it in your router — the cells use it internally only.

### Missing `pgv/` in LP variant
`sky130_scl_9T_LP/` does not have a `pgv/` directory (unlike base and HS). If your PG analysis tool requires it, use the base or HS `pgv/` as a starting point and re-characterize, or skip PG via analysis for LP.

### Quantus tech dir path in DSPF headers
DSPF files contain a comment: `** QRC_TECH_DIR /vols/wfo_devel/.../quantus/extraction/typical`. This is an internal Cadence path — it is informational only and does not affect simulation. The actual Quantus setup for your run is in `sky130_release_0.1.0/quantus/extraction/typical/`.

### Model naming (post-0.0.2 change)
From release 0.0.2 onward, model names no longer carry the `sky130_fd_pr__` prefix. If you have older simulation decks that reference `sky130_fd_pr__nfet_01v8`, strip the prefix to `nfet_01v8` to match the current library.

### Corner files vs continuous models
For standard block-level simulation use `models/corners/<corner>.spice`.  
For AMS simulation where you need all devices in one SPICE session use `models/continuous/sky130.lib.spice`.  
For statistical/Monte Carlo use `models/parameters/montecarlo.spice`.

---

*Generated by scanning sky130_die_collateral_1.1, sky130_release_0.1.0, and sky130_scl_9T_0.1.1 — June 2026*
