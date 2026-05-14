# Beyond Graph Neural Networks: Rethinking Node Classification with Community-Enhanced Machine Learning

Repository containing the code and datasets used in the development of the article [Beyond Graph Neural Networks: Rethinking Node Classification with Community-Enhanced Machine Learning].

## Description

This repository gathers the scripts, notebooks, and datasets used for the experiments, analyses, and results presented in the research work.

The main objective is to facilitate the reproducibility of the results and provide supporting material for future research.

## Repository Structure

── data/
│   ├── raw/                # Datos originales
│   ├── processed/          # Datos procesados
│   └── external/           # Datos externos o complementarios
│
├── notebooks/              # Jupyter notebooks para análisis y experimentación
│
├── src/                    # Código fuente principal
│   ├── preprocessing/      # Scripts de limpieza y transformación
│   ├── models/             # Modelos y entrenamiento
│   ├── evaluation/         # Evaluación y métricas
│   └── utils/              # Funciones auxiliares
│
├── results/                # Resultados, gráficas y outputs
│
├── requirements.txt        # Dependencias del proyecto
└── README.md

## Usage

1. Clone the repository
   
2. Run the code
   
   * 1_Splits
   * 2_Experiment


## Datasets

Known open-access graph datasets in Node Classification tasks

<p align="center">
  <img src="images/datasets.png" width="700"/>
</p>

## Technologies Used

R

## Other comments

#### 1_Splits

* The path for saving all splits is specified after the “Splits path” comment
* The splits path and files could not be created in this repository due to GitHub's specifications.

#### 2_Experiment

* The path for saving CV training results is specified after the “Save CV results on path” comment
* The CV training results path and files could not be created in this repository due to GitHub's specifications.
  
## Author

Eduardo Martinez Tena
