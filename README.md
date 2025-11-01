# Data-Driven and Machine Learning Framework for Alfalfa Yield Response to Long-Term Climate Variability in the Kansas High Plains (USA)

**Authors:** Farshina Nazrul¹, Jiyung Kim², Sourajit Dey², Bradley Whitaker¹, Debjani Sihi³, Doohong Min², Gaurav Jha²*  
**Affiliations:**  
¹ Department of Electrical & Computer Engineering, Montana State University, Bozeman, MT, USA  
² Department of Agronomy, Kansas State University, Manhattan, KS, USA  
³ Department of Plant and Microbial Biology, N.C. State University, Raleigh, NC, USA  
*Corresponding author: Gaurav Jha (gjha@ksu.edu)  

---

## Overview

This repository contains MATLAB code and datasets used in the study:

> *"Data-Driven and Machine Learning Framework for Alfalfa Yield Response to Long-Term Climate Variability in the Kansas High Plains (USA)"*

The study presents a machine learning-based modeling framework to identify key agro-climatic predictors of alfalfa (Medicago sativa L.) yield across Kansas (1981–2018). Using 117 climate-derived features from PRISM and yield data from USDA-NASS, we applied Minimum Redundancy Maximum Relevance (mRMR) feature selection, followed by forward selection using SVM, KNN, and Random Forest models with 5-fold cross-validation.

---

## Repository Structure

### Main Codes (Parent Directory)

| File | Description |
|------|-------------|
| `main_yieldKSfs_mRMR_modelbased.m` | Main script: mRMR feature ranking, regression using SVM, KNN, RF, 5-fold CV. Computes RMSE for 1–117 features. |
| `main_yieldKSfs_pearsons_modelbased.m` | Same as above but with Pearson correlation-based feature ranking. |
| `mRMR_topfeatures_plotmatrix.m` | Generates a matrix-style plot of final selected mRMR features (Supplement Section 6). |
| `plot_mRMR.m` | Main file for plotting the final selected feature set. |
| `curseofdimentionality_datatofeatureratio.m` | Plots features-to-data ratio per fold to illustrate curse of dimensionality (Supplement Section 2). |
| `correlation_pearson_spearman.m` | Computes full Pearson’s and Spearman’s correlation matrices; generates plots and CSV files (Supplement Section 1). |

### Dataset Generalization and Visualization Codes (`dataset_generalization/`)

> All scripts in this folder assume the `dataset` folder is in the parent directory (`../dataset/`).

| File | Description |
|------|-------------|
| `main_yieldKSdataset_total.m` | Combines all Kansas county USDA-NASS yield data (1981–2018) with daily PRISM weather data; generates a `county_year_yieldinfo.txt`. |
| `missingyield_countyyear.m` | Identifies missing yield reporting years per county (Supplement Section 4). |
| `prism_ppp_plot.m`, `prism_temp_plots.m`, `yieldfs_plots.m` | Generate figures of yearly yield, precipitation, and temperature across counties (Section 3.1). |

### 📁 correlation_matrix/
This folder contains four `.csv` files with Pearson and Spearman correlation coefficients:

- **Target vs Predictors**  
  - Pearson correlation (117 x 1)  
  - Spearman correlation (117 x 1)

- **Predictors vs Predictors**  
  - Pearson correlation (117 × 117)  
  - Spearman correlation (117 × 117)

These files provide pairwise correlation information used for model interpretation and variable selection.

### 📁 dataset_and_results_figures/
This folder includes all visualizations and performance plots used in the manuscript and supplementary materials:

- Dataset visualizations  
- Results surface plots, bar charts, and model performance plots  
- Figures are named according to the manuscript convention  
  (e.g., `Fig1a....png`, `FigS1a....png` where *S* denotes *Supplementary*)  

A MATLAB script for converting `.fig` files to `.png` format is also included in this folder.

### 📝 Notes
These additions aim to improve the transparency and reproducibility of the analysis by providing both correlation data and all visual outputs used in the study.

---

## Requirements

- **MATLAB R2023a**  
- **Statistics and Machine Learning Toolbox™**  
- Internal seeding for reproducibility (`rng` with seed 0) is applied in all scripts.  
- External mRMR implementation via `fsrmrmr` function from MATLAB Statistics and Machine Learning Toolbox.  

---

## Dataset

The repository does **not** include raw data.  
> Dataset download link available upon request to the corresponding author (USDA-NASS and PRISM data).  

---

## Usage

1. Open MATLAB and set the parent directory as the working folder.  
2. Run main scripts directly, for example:  
   ```matlab
   main_yieldKSfs_mRMR_modelbased
3. After running the feature selection scripts, plotting and analysis can be performed using:

- `plot_mRMR.m` for feature visualization  
- Visualization scripts in `dataset_generalization/` for climate and yield plots  

All scripts are designed for reproducibility using internal random seeds.

---

## Outputs

The repository produces:

- RMSE results for incremental feature sets (1–117) using SVM, KNN, and RF  
- Pearson and Spearman correlation matrices, with corresponding CSV files  
- Figures for the main paper and supplemental sections as described in the scripts  

---

## License

This repository is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

---

## Citation

A citation will be available via **Zenodo** upon publication. Please contact the corresponding author for dataset access or related questions.

---

## Contact

- **Code and implementation details:** Farshina Nazrul — <farshinashimim@montana.edu>  
- **Corresponding author:** Gaurav Jha — <gjha@ksu.edu>
