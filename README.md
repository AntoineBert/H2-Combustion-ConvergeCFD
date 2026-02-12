# H2 Engine Combustion Modeling  
### From 3D ConvergeCFD to 1D GT-Power Combustion Profile

**Author:** Antoine BERTRAND  
**Academic Year:** 2024/2025  

---

## 📌 Project Overview

This project develops a combustion modeling workflow to convert high-fidelity **3D ConvergeCFD simulations** into a reduced-order **1D GT-Power combustion profile model**.

The objective is to:

- Extract species mass data from ConvergeCFD
- Compute the **Mass Fraction Burned (MFB)**
- Interpolate MFB curves across different **SOC** (Start of Combustion) and **ϕ** (equivalence ratio)
- Generate combustion maps (CA50, burn completion)
- Export GT-Power compatible combustion profiles

This approach enables fast parametric studies using a physics-based interpolation of CFD results.

---

# 📂 Project Structure

```
H2_Engine_Project/
│
├── main.mlx # Main workflow (Live Script)
│
├── src/ # MATLAB interpolation functions
│ ├── interMFB_SOC.m
│ ├── interMFB_PHI.m
│ └── interMFB_SOC_PHI.m
│
├── data/ # Intermediate data files
│ ├── Cases.txt
│ ├── species_mass_case_#.txt
│ └── MFB_case_#.txt
│
├── results/ # Generated outputs and maps
│
├── ConvergeCFD/
│ ├── Run_simulation.sh
│ ├── Inputs/
│ └── Outputs/
│
└── docs/ # Documentation / reports
```

---

# 🔬 Workflow Description

## I. Compute MFB from H₂ Mass Fraction

1. Extract species mass data from:
species_mass_region_0.out

diff
Copier le code
2. Export relevant variables:
- Crank Angle (deg)
- Mass_H2 (kg)
- Mass_O2 (kg)
- Mass_H2O (kg)
- Mass_OH (kg)

3. Select:
- Start of Combustion (SOC)
- End of Combustion window

4. Compute Mass Fraction Burned:

\[
MFB = \frac{m_{H2,initial} - m_{H2}}{m_{H2,initial}}
\]

5. Enforce:
- Monotonic increase
- Positivity
- Maximum 1000 points (GT-Power requirement)

6. Export:
MFB_case_#.txt

---

## II. Interpolation of MFB Curves

The model performs:

### 1️⃣ Interpolation across SOC (fixed ϕ)

Function:
interMFB_SOC.m

makefile
Copier le code

### 2️⃣ Interpolation across ϕ (fixed SOC)

Function:
interMFB_PHI.m

makefile
Copier le code

### 3️⃣ Double interpolation (SOC + ϕ)

Function:
interMFB_SOC_PHI.m

Methodology:

- Interpolation performed at fixed MFB reference values
- Horizontal crank angle translation
- Linear interpolation across parameter space

---

## III. Combustion Mapping

The workflow generates:

- 🔥 Fuel Burn Completion Map  
  (MFB @ 130°CA)

- 🎯 CA50 Map  
  (Crank angle at 50% fuel burned)

Interpolated over:
```
SOC ∈ [-10, 10]
ϕ ∈ [0.3, 0.9]
```

---

## IV. GT-Power Integration

The generated MFB curves are formatted for the:

```
EngCylCombProfile
```

module in GT-Power.

Important:

- Curves start at CA = 0
- SOC shift is handled directly inside GT-Power

---

# ⚙️ Requirements

- MATLAB (tested with R2023b+)
- ConvergeCFD
- GT-Power

---

# 🚀 How to Use

1. Run ConvergeCFD simulations.
2. Export species mass data into `/data`.
3. Open `main.mlx`.
4. Execute sections sequentially:
   - MFB computation
   - Interpolation
   - Map generation
   - Export combustion profiles

---

# 📊 Outputs

- Interpolated MFB curves
- SOC–ϕ combustion maps
- CA50 contour lines
- GT-Power ready combustion profile files

---

# 🧠 Modeling Philosophy

This project bridges:

- High-fidelity CFD combustion physics  
- Reduced-order 1D engine simulation  

The interpolation strategy preserves:

- Physical monotonicity of burn fraction
- Smooth crank-angle evolution
- Parameter continuity across SOC and equivalence ratio

---

# 📬 Contact

For questions or collaboration:

Antoine BERTRAND  
MSc Mechanical Engineering  

---