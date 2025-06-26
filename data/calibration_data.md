# Model Calibration Parameters
This document provides detailed information about the parameters used to calibrate the HIV transmission simulation model with real-world data from the Philippines. The calibration process involved adjusting model parameters to align simulated outcomes with observed HIV infection trends from 2010 to 2018.

## Overview
The model calibration was performed using empirical data from multiple credible sources in the Philippines to ensure the simulation accurately reflects real-world HIV transmission dynamics. The parameter values represent estimates based on available statistical data and epidemiological studies, acknowledging that exact values are often difficult to obtain and may vary across different studies.

## Default Parameter Configuration
The following table presents the baseline parameter values used in the simulation, along with their data sources and rationale:

| Parameter | Value | Unit | Source | Description |
|-----------|-------|------|--------|-------------|
| `initial-people` | 5,000 | agents | Model Design | Total population size for computational efficiency |
| `infection-chance` | 2% | per exposure | Literature Standard | Transmission probability per unprotected sexual encounter |
| `symptoms-show` | 1,400 | days (~3.8 years) | Clinical Literature | Time from infection to symptom manifestation |
| `initial-infected-rate` | 8% | of population | UNAIDS (2019) | Initial HIV prevalence in high-risk populations |
| `initial-drug-user-rate` | 1.25% | of population | DDB (2019), Drug Archive | Estimated PWID prevalence in Philippines |

## Behavioral Parameters

### Sexual Behavior and Relationship Dynamics

| Parameter | Value | Range/Scale | Source | Notes |
|-----------|-------|-------------|--------|-------|
| `average-coupling-tendency` | 30% | 0-100% | UPPI (2022) | Likelihood of forming sexual relationships |
| `average-commitment` | 523 days | ~1.4 years | Freeman et al. (2023) | Average relationship duration |
| `average-condom-use` | 40% | 0-100% | UNAIDS (2021) | Consistent condom usage rates |

### Healthcare and Testing Behavior

| Parameter | Value | Scale | Source | Rationale |
|-----------|-------|-------|--------|-----------|
| `average-test-frequency` | 1 time/year | 0-2 times/year | PSA ICF (2023) | HIV testing frequency in general population |
| `average-treatment-tendency` | 40% | 0-100% | UNAIDS (2021) | Treatment uptake rates among diagnosed individuals |

### Risk Behaviors

| Parameter | Value | Scale | Source | Context |
|-----------|-------|-------|--------|---------|
| `average-drug-tendency` | 1% | 0-100% | DOH-EB (2016) | General population drug use inclination |

## Calibration Constants

### Transmission Dynamics
- **Base infection chance**: 2% per unprotected sexual encounter
- **Condom effectiveness**: 80% (applied as 0.8 multiplier to base transmission risk)
- **Treatment effect**: 20% reduction in transmission probability (random float up to 20)
- **Awareness effect**: +1 increase in condom use tendency when infection status is known

### Testing and Diagnosis
- **Symptom-triggered testing**: 10% chance when symptoms appear (after 1,400 days)
- **Partner-awareness testing**: 10% chance when partner tests positive
- **Annual testing**: Based on individual test-frequency parameter (1-2 times per year)

### Treatment Initiation
- **Treatment threshold**: 50% treatment tendency required for automatic treatment
- **Symptom-triggered treatment**: 50% chance of increased treatment tendency when symptoms appear

## Data Sources and References

### Primary Data Sources
1. **UNAIDS (2019)**: Global HIV prevalence estimates for high-risk populations
2. **UNAIDS (2021)**: Treatment coverage and condom usage statistics
3. **UPPI (2022)**: University of the Philippines Population Institute - Sexual behavior surveys
4. **PSA ICF (2023)**: Philippine Statistics Authority - Health testing behavior data
5. **DOH-EB (2016)**: Department of Health Epidemiology Bureau - Risk behavior surveillance
6. **DDB (2019)**: Dangerous Drugs Board - Drug use prevalence estimates
7. **Drug Archive**: Historical drug use statistics in the Philippines

### Validation Data Sources
- **HARP (2010-2018)**: HIV and AIDS Repository Project annual reports
- **Philippine Department of Health**: Official HIV case reporting
- **WHO Philippines**: HIV surveillance data

## Parameter Estimation Methodology

### Data Collection Approach
1. **Literature Review**: Systematic review of peer-reviewed publications
2. **Government Reports**: Official statistics from health departments
3. **Survey Data**: Population-based behavioral surveys
4. **Expert Consultation**: Input from local epidemiologists and public health experts

### Calibration Process
1. **Initial Parameter Setting**: Based on literature values
2. **Sensitivity Testing**: Individual parameter impact assessment
3. **Iterative Adjustment**: Fine-tuning to match observed trends
4. **Validation**: Comparison with 2010-2018 Philippines HIV data

## Model Validation Results

The calibrated model achieved the following accuracy metrics when compared to Philippines HIV data (2010-2018):

- **Mean Absolute Error (MAE)**: 3.5%
- **Mean Squared Error (MSE)**: 14.9
- **Trend Correlation**: Strong positive correlation with observed annual infection increases
- **Peak Prediction**: Successfully captures cyclical infection patterns (2-3 year cycles)

## Uncertainty and Limitations

### Parameter Uncertainty
- **Data Availability**: Some parameters estimated due to limited Philippines-specific data
- **Population Heterogeneity**: Single values represent population averages
- **Temporal Variation**: Parameters may change over time but are held constant in simulation

### Model Assumptions
- **Fixed Population**: No births, deaths, or migration
- **Constant Behaviors**: Individual tendencies remain stable over simulation period
- **Simplified Relationships**: Complex social networks reduced to pairwise interactions

## Sensitivity Analysis Configuration

The following parameter ranges were used for sensitivity analysis:

| Parameter | Test Values | Increment | Total Scenarios |
|-----------|-------------|-----------|-----------------|
| `average-commitment` | 0, 280, 560, 840, 1120, 1400 days | 280 days | 6 |
| `average-condom-use` | 0, 2, 4, 6, 8, 10 (0-100%) | 2 units | 6 |
| `average-test-frequency` | 0, 1, 2 times/year | 1 time | 3 |
| `average-treatment-tendency` | 0, 2, 4, 6, 8, 10 (0-100%) | 2 units | 6 |
| `average-drug-tendency` | 0, 2, 4, 6, 8, 10 (0-100%) | 2 units | 6 |
| `average-coupling-tendency` | 0, 2, 4, 6, 8, 10 (0-100%) | 2 units | 6 |

**Total simulation runs**: 825 (33 scenarios × 25 repetitions each)

## Usage Notes

### Modifying Parameters
When adapting this model for different populations or regions:

1. **Update demographic parameters** based on local population data
2. **Adjust behavioral parameters** using region-specific survey data
3. **Calibrate transmission parameters** against local HIV prevalence data
4. **Validate results** against observed infection trends

### Parameter File Format
Parameters can be modified directly in the NetLogo interface or through batch experiments:

```netlogo
; Example parameter modification in NetLogo code
set average-coupling-tendency 30
set average-commitment 523
set average-condom-use 40
set average-test-frequency 1
set average-treatment-tendency 40
set average-drug-tendency 1
```

---

**For complete methodology and detailed analysis, refer to the full research paper published in PLOS ONE: [JOURNAL LINK PLACEHOLDER]**
