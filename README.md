# chervil
Computational Human Endogenous RetroVIral Labeling is a pipeline and analytical tool for detection of endogenous retroviral expression features that correspond to current or previous viral infection. 

## What is chervil and why do we need it?
Human Endogenous Retroviral Elements (hERVs) are typically latent in the human genome. However, previous work suggests that some hERVs become actively transcribed upon viral infection. Chervil uses differential expression analysis of hERVs in healthy and infected popuations (e.g. RNA-seq) in an attempt to develop a diagnostic tool for detection of pre-symptomatic or historic viral infection. 

Chervil builds on an exisiting pipelins built for hERV detection (RetroSpotter) and adds on a machine learning component to identify patterns in hERV expression specific to distinct viral infections. 


## Overview Diagram of Workflow

### RetroSpotter Plus
* Utilize RetroSpotter to identify differentially expressed hERVs in infected populations 
    + Supply SRA accession numbers for expression dataset of healthy and infection of interest
    +
    +
* Apply Machine Learning Algorithm to identify classifiers of hERVS specific to viral infection
    +
    +
    +

### Novel Pipeline
* Create new pipeline for RNAseq analysis using Rsubread 
    + 
    +
    +
* Apply Machine Learning Algorithm to identify classifiers of hERVS specific to viral infection

### Example Dataset
* PRJNA349748: Human Tracheobronchial Epithelial (HTBE) cells infected with Influenza
    + Data Type: RNA-seq
    + Conditions / Samples: H1N1, H5N1, H3N2, mock-infected controls
* PRJNA429171: HuH7 cells infected with Ebola and Marburg Virus
    + Data Type: RNA-seq
    + Conditions / Samples: Ebola, Margburg, mock-infected contrls
    


## How to use chervil

## Software Workflow Diagram

## File Structure Diagram

## Install Instructions


