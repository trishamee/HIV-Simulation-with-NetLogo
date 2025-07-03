# HIV Transmission Dynamics Simulation Model
**This is the supporting repository for the research article to be published in PLOS ONE, titled "Simulating HIV Transmission Dynamics: An Agent-Based Approach Using NetLogo."**

## Overview
This repository contains the complete NetLogo simulation model, raw datasets, and implementation guides for the HIV transmission dynamics research. The model represents an enhanced agent-based approach that incorporates multiple subpopulations and their complex interactions to understand HIV spread patterns.

📄 **Read the full research paper**: [JOURNAL LINK PLACEHOLDER]
📖 **Detailed explanation**: [Medium Article Link Placeholder]

## Key Features
- **Enhanced Agent-Based Model**: Simulates individual agents with diverse characteristics and behaviors
- **Multi-Population Dynamics**: Incorporates gender dynamics, drug use patterns, and sexual behaviors
- **Real-World Calibration**: Parameters derived from Philippines HIV data (2010-2018)
- **Comprehensive Analysis**: Sensitivity analysis (OFAT) across six key factors
- **Open Source**: Full code and data available for research and educational use

## 📁 Repository Structure

```text
├── src/
│   └──  HIV-Simulation.nlogo            # Main NetLogo simulation file
└── data/
    ├── raw-results/                    # Complete simulation datasets
    │   ├── base-simulation/            # Default parameter results
    │   ├── commitment-analysis/        # Commitment length variations
    │   ├── condom-use-analysis/        # Condom use tendency analysis
    │   ├── test-frequency-analysis/    # Testing frequency scenarios
    │   ├── treatment-tendency-analysis/# Treatment seeking behavior
    │   ├── drug-tendency-analysis/     # Drug use pattern analysis
    │   └── coupling-tendency-analysis/ # Sexual behavior patterns
    ├── calibration-data/               # Philippines HIV reference data
    └── summarized-results/             # Summarized result tables
```


## Quick Start

### Prerequisites
- [NetLogo 6.4.0+](https://ccl.northwestern.edu/netlogo/download.shtml)

### Installation
1. Download and install NetLogo
2. Clone this repository:
   `git clone https://github.com/trishamee/HIV-Simulation-with-NetLogo.git`
3. Open `src/HIV-Simulation.nlogo` in NetLogo
4. Follow the parameter setup guide in `/guides/`

### Running Your First Simulation
1. Launch NetLogo and open the model file
2. Click "setup" to initialize the simulation
3. Adjust parameters using the interface sliders
4. Click "go" to run the simulation
5. Observe real-time visualization and plots

## Model Parameters
The simulation includes six key parameters for sensitivity analysis:

| Parameter | Range | Description |
|-----------|-------|-------------|
| `average-commitment` | 0-1400 days | Average relationship duration |
| `average-condom-use` | 0-10 (0-100%) | Condom usage tendency |
| `average-test-frequency` | 0-2 times/year | HIV testing frequency |
| `average-treatment-tendency` | 0-10 (0-100%) | Treatment seeking behavior |
| `average-drug-tendency` | 0-10 (0-100%) | Drug use inclination |
| `average-coupling-tendency` | 0-10 (0-100%) | Sexual relationship formation |

## Dataset Information

### Raw Simulation Results
- **Format**: CSV files with standardized headers
- **Scope**: 25 simulation runs per scenario
- **Population**: 5,000 agents per simulation
- **Duration**: 10-year projection period
- **Total scenarios**: 33 parameter combinations (825 total runs)

## Calibration and Validation

The model is calibrated against Philippines HIV infection data (2010-2018):
- **Mean Absolute Error (MAE)**: 3.5
- **Mean Squared Error (MSE)**: 14.9
- **Data Sources**: HIV and AIDS Repository Project (HARP)
- **Reference Period**: 2010-2018
- **Validation Approach**: Year-over-year percentage increase comparison

## Research Applications
This model can be used for:
- **Academic Research**: HIV transmission dynamics studies
- **Policy Analysis**: Intervention strategy evaluation
- **Educational Purposes**: Teaching computational epidemiology
- **Public Health Planning**: Scenario modeling and prediction
- **Comparative Studies**: Cross-population analysis

## Citation

If you use this model or datasets in your research, please cite:

```bibtex
[CITATION PLACEHOLDER - Will be updated upon publication]
```

## Data Availability Statement
All simulation data and code are made freely available for research and educational purposes.


## Related Publications
- Main Research Paper: [JOURNAL LINK PLACEHOLDER]
- Medium Article: [Simulating HIV Transmission Dynamics](https://medium.com/@tri.beleta/simulating-hiv-transmission-dynamics-an-agent-based-approach-using-netlogo-2eab9790e37e)

---

**For complete research methodology, detailed results, and comprehensive analysis, please refer to the full journal article to be published in PLOS ONE.**

**Keywords**: `HIV-transmission` `agent-based-modeling` `netlogo` `computational-epidemiology` `public-health` `simulation` `philippines` `open-science`
