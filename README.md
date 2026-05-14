# Título del Proyecto

Repositorio con el código y los datasets utilizados en el desarrollo del artículo de tesis [Título de la tesis o artículo].

## Descripción

Este repositorio reúne los scripts, notebooks y conjuntos de datos empleados para los experimentos, análisis y resultados presentados en el trabajo de investigación.

El objetivo principal es facilitar la reproducibilidad de los resultados y servir como material de apoyo para futuras investigaciones.

## Contenido del repositorio

.
├── data/
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

## Requisitos

Instala las dependencias necesarias con:

pip install -r requirements.txt

## Uso

1. Clonar el repositorio

git clone https://github.com/tu-usuario/tu-repositorio.git
cd tu-repositorio

2. Preparar los datos

Coloca los datasets en la carpeta correspondiente:

data/raw/

3. Ejecutar el código

Ejemplo:

python src/main.py

O ejecutar notebooks:

jupyter notebook

## Datasets

Los datasets utilizados en esta investigación incluyen:

Dataset 1: descripción breve.

Dataset 2: descripción breve.

Dataset 3: descripción breve.

Si algún dataset no puede compartirse públicamente por motivos de licencia o privacidad, se indicará explícitamente.

## Tecnologías utilizadas

R

## Otros comentarios

#### 1_Splits

* The path for saving all splits is specified after the “Splits path” comment
* The splits path and files could not be created in this repository due to GitHub's specifications.

#### 2_Experiment

* The path for saving CV training results is specified after the “Save CV results on path” comment
* The CV training results path and files could not be created in this repository due to GitHub's specifications.
  
## Autor

Eduardo Martinez Tena
