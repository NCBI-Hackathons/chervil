![logo](images/logo.png)

Computational Human Endogenous RetroViral Infection Labeler (CHERVIL) is a pipeline for the detection of endogenous retroviral expression patterns that correspond to current or previous viral infection.


![ERV](images/ERV.png)


## What is CHERVIL and why do we need it?
Human endogenous retroviral elements (HERVs) are retroviruses that have integrated themselves into the human germline. Usually, they remain latent in the human genome. However, previous work suggests that some HERVs become actively transcribed upon viral infection. CHERVIL uses differential expression analysis of HERVs in healthy and infected populations via RNA-seq in  to detect pre-symptomatic or historic viral infection.

CHERVIL builds on an existing pipeline built for HERV detection, [RetroSpotter](https://github.com/NCBI-Hackathons/RetroSpotter), and adds on a machine learning component to identify patterns in HERV expression specific to distinct viral infections.

## How it works

![pipeline](images/pipeline.png)

At a high level, there are two major phases of the CHERVIL pipeline.

The first is the calculation of HERV expression in different populations. To do this, we use RetroSpotter and Magic-BLAST to align RNA-seq data to known HERVs to quantify HERV expression.

The second phase is the automatic development of a machine learning pipeline that uses expression data to predict disease status. We accomplish this using [TPOT](https://github.com/EpistasisLab/tpot) to identify HERV expression patterns specific to viral infection.

## Installation

### Docker

#### From Docker Hub

We have provided a Docker image with our pipeline pre-installed. To download it (assuming you already have Docker installed), run:

    $ docker pull benjamindlee/chervil

#### From Dockerfile

Alternatively, you can build the image yourself from our dockerfile:

    $ docker build -t chervil .

### Manually

Before proceeding, ensure that you have the following installed and functional:

1. [R 3.5 or greater](https://cran.r-project.org)
2. [Python 3.6 or greater](https://www.python.org/downloads/release/python-365/)
3. [Magic-BLAST](https://ncbi.github.io/magicblast/)
4. [A towel](https://en.wikipedia.org/wiki/Towel_Day#Origin)

Next, clone a copy of the repository:

    $ git clone https://github.com/NCBI-Hackathons/chervil.git

and then `cd` into it:

    $ cd chervil

Odds are that you will want to run CHERVIL in a [virtual environment](https://virtualenv.pypa.io/en/stable/). If you don't have virtualenv installed, run:

    $ pip install virtualenv

And then to set up your shiny new virtual environment:

    $ virtualenv env --python=python3.6
    $ source env/bin/activate

Next, to install the Python components, run:

    (env) $ pip install -r requirements.txt

Once you've installed the Python requirements, install [XGBoost](https://xgboost.readthedocs.io/en/latest/build.html). Be sure to [install the Python bindings](http://xgboost.readthedocs.io/en/latest/build.html#python-package-installation) for XGBoost as well.

## How to use CHERVIL

1. **Create blast database with HERV elements**

    Users will need to create a FASTA file containing the nucleotide sequence of each HERV element. For convenience, we have included a [set](reference_genome/her_reference.fasta) of known HERV sequences. The `makeblastdb.sh` command creates a blast database:

        $ makeblastdb.sh reference_genome/her_reference.fasta

    This creates a directory `blastdb` containing a reference database called `referencedb`.

2. **Input accession numbers and their classifications**

    This should in the form of a CSV file that looks something like this:
    ```csv
    SRR123456, infected
    SRR789101, infected
    SRR112131, infected
    SRR415161, control
    SRR718192, control
    SRR021222, control
    ```
    (note: these are made-up accessions)

3. **Generate the HERV classification machine learning model**

    Assuming you are in a directory with accessions and their classes, run:

        $ chervil.sh [path to SRR acession file] [path to blast database] [number of cores] [output directory] [prefix for SAM files]

    Example usage:

        $ chervil.sh srr_inf_test.csv ../blast_dbs/referencedb 20 out "test"

    This command calls multiple scripts that execute the pipeline we have developed.

    * Uses `magicblast` command align RNA-seq reads to the reference blast database.  Generates a SAM file for each patient. (`S1_make_acc_file.r`, `run_jobs.sh`)

    * Takes the SAM files and count the number of reads corresponding to each ERV gene. (`count_hits.sh`)

    * Organizes the counts into a dataframe that includes all of the sample numbers (by SRR accession), their class (infected, not infected, etc.) and their read count for each ERV gene, written to a CSV file. (`S2_orgCountsScript.r`)

    * Feeds this dataframe into TPOT, an automated machine learning pipeline. The model and an HTML file with a confusion matrix table with performance measures for external data set are then saved for analysis. (`S3_generate_classifier.py`)

## Example Dataset
* PRJNA349748: Human Tracheobronchial Epithelial (HTBE) cells infected with Influenza
    + Data Type: RNA-seq
    + Samples:
        + 10 H1N1, H5N1, and H3N2 infected cells
        + 5 mock-infected controls

## Example Report

2-fold Cross Validation accuracy: .917   
Validation accuracy: .75

<table>
<tr  align="center">
<td>Actual</td>
<td>Predict
<table style="border:1px solid black;border-collapse: collapse;height:285px;width:285px;">
<tr align="center">
<td></td>
<td style="border:1px solid black;padding:10px;height:95px;width:95px;">infected</td>
<td style="border:1px solid black;padding:10px;height:95px;width:95px;">not_infected</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:10px;height:95px;width:95px;">infected</td>
<td style="background-color:	rgb(64,64,64);color:white;padding:10px;height:95px;width:95px;">3</td>
<td style="background-color:	rgb(255,255,255);color:black;;padding:10px;height:95px;width:95px;">0</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:10px;height:95px;width:95px;">not_infected</td>
<td style="background-color:	rgb(128,128,128);color:black;;padding:10px;height:95px;width:95px;">1</td>
<td style="background-color:	rgb(255,255,255);color:black;;padding:10px;height:95px;width:95px;">0</td>
</tr>
</table>
</td>
</tr>
</table>
<h4> Overall Statistics: </h4>
<table style="border:1px solid black;border-collapse: collapse;">
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#95%-CI" style="text-decoration:None;">95% CI</a></td>
<td style="border:1px solid black;padding:4px;">(0.32565,1.17435)</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Bennett-et-al.'s-S-score-(Nominal)" style="text-decoration:None;">Bennett_S</a></td>
<td style="border:1px solid black;padding:4px;">0.5</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Chi-Squared" style="text-decoration:None;">Chi-Squared</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Chi-Squared-DF" style="text-decoration:None;">Chi-Squared DF</a></td>
<td style="border:1px solid black;padding:4px;">1</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Conditional-Entropy" style="text-decoration:None;">Conditional Entropy</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Cramer's-V" style="text-decoration:None;">Cramer_V</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Cross-Entropy" style="text-decoration:None;">Cross Entropy</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Gwet's-AC1" style="text-decoration:None;">Gwet_AC1</a></td>
<td style="border:1px solid black;padding:4px;">0.68</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Joint-Entropy" style="text-decoration:None;">Joint Entropy</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Kullback-Liebler-(KL)-divergence" style="text-decoration:None;">KL Divergence</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Kappa-(Nominal)" style="text-decoration:None;">Kappa</a></td>
<td style="border:1px solid black;padding:4px;">0.0</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Kappa-95%-CI" style="text-decoration:None;">Kappa 95% CI</a></td>
<td style="border:1px solid black;padding:4px;">(-1.69741,1.69741)</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Kappa-No-Prevalence" style="text-decoration:None;">Kappa No Prevalence</a></td>
<td style="border:1px solid black;padding:4px;">0.5</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Kappa-95%-CI" style="text-decoration:None;">Kappa Standard Error</a></td>
<td style="border:1px solid black;padding:4px;">0.86603</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Kappa-Unbiased" style="text-decoration:None;">Kappa Unbiased</a></td>
<td style="border:1px solid black;padding:4px;">-0.14286</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Goodman-and-Kruskal's-lambda-A" style="text-decoration:None;">Lambda A</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Goodman-and-Kruskal's-lambda-B" style="text-decoration:None;">Lambda B</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/#Mutual-Information" style="text-decoration:None;">Mutual Information</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Overall_ACC" style="text-decoration:None;">Overall_ACC</a></td>
<td style="border:1px solid black;padding:4px;">0.75</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Overall_RACC" style="text-decoration:None;">Overall_RACC</a></td>
<td style="border:1px solid black;padding:4px;">0.75</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Overall_RACCU" style="text-decoration:None;">Overall_RACCU</a></td>
<td style="border:1px solid black;padding:4px;">0.78125</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#PPV_Macro" style="text-decoration:None;">PPV_Macro</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#PPV_Micro" style="text-decoration:None;">PPV_Micro</a></td>
<td style="border:1px solid black;padding:4px;">0.75</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Phi-Squared" style="text-decoration:None;">Phi-Squared</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Reference-Entropy" style="text-decoration:None;">Reference Entropy</a></td>
<td style="border:1px solid black;padding:4px;">0.81128</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Response-Entropy" style="text-decoration:None;">Response Entropy</a></td>
<td style="border:1px solid black;padding:4px;">None</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#Scott's-pi-(Nominal)" style="text-decoration:None;">Scott_PI</a></td>
<td style="border:1px solid black;padding:4px;">-0.14286</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#95%-CI" style="text-decoration:None;">Standard Error</a></td>
<td style="border:1px solid black;padding:4px;">0.21651</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#SOA3-(Strength-of-Agreement,-Altman%E2%80%99s-benchmark)" style="text-decoration:None;">Strength_Of_Agreement(Altman)</a></td>
<td style="border:1px solid black;padding:4px;background-color:Red;">Poor</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#SOA4-(Strength-of-Agreement,-Cicchetti%E2%80%99s-benchmark)" style="text-decoration:None;">Strength_Of_Agreement(Cicchetti)</a></td>
<td style="border:1px solid black;padding:4px;background-color:Red;">Poor</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#SOA2-(Strength-of-Agreement,-:-Fleiss%E2%80%99-benchmark)" style="text-decoration:None;">Strength_Of_Agreement(Fleiss)</a></td>
<td style="border:1px solid black;padding:4px;background-color:Red;">Poor</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#SOA1-(Strength-of-Agreement,-Landis-and-Koch-benchmark)" style="text-decoration:None;">Strength_Of_Agreement(Landis and Koch)</a></td>
<td style="border:1px solid black;padding:4px;background-color:Orange;">Slight</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TPR_Macro" style="text-decoration:None;">TPR_Macro</a></td>
<td style="border:1px solid black;padding:4px;">0.5</td>
</tr>
<tr align="center">
<td style="border:1px solid black;padding:4px;text-align:left;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TPR_Micro" style="text-decoration:None;">TPR_Micro</a></td>
<td style="border:1px solid black;padding:4px;">0.75</td>
</tr>
</table>
<h4>Class Statistics : </h4>
<table style="border:1px solid black;border-collapse: collapse;">
<tr align="center">
<td>Class</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">infected</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">not_infected</td>
<td>Description</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#ACC-(accuracy)" style="text-decoration:None;">ACC</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.75</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.75</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Accuracy</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#BM-(Informedness-or-Bookmaker-Informedness)" style="text-decoration:None;">BM</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Informedness or bookmaker informedness</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#DOR-(Diagnostic-odds-ratio)" style="text-decoration:None;">DOR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Diagnostic odds ratio</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#ERR(Error-rate)" style="text-decoration:None;">ERR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.25</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.25</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Error rate</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FBeta-Score" style="text-decoration:None;">F0.5</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.78947</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">F0.5 score</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FBeta-Score" style="text-decoration:None;">F1</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.85714</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">F1 score - harmonic mean of precision and sensitivity</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FBeta-Score" style="text-decoration:None;">F2</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.9375</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">F2 score</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FDR-(false-discovery-rate)" style="text-decoration:None;">FDR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.25</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">False discovery rate</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FN-(False-negative/miss/Type-II-error)" style="text-decoration:None;">FN</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">False negative/miss/type 2 error</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FNR-(miss-rate-or-false-negative-rate)" style="text-decoration:None;">FNR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Miss rate or false negative rate</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FOR-(false-omission-rate)" style="text-decoration:None;">FOR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.25</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">False omission rate</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FP-(False-positive/false-alarm/Type-I-error)" style="text-decoration:None;">FP</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">False positive/type 1 error/false alarm</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#FPR-(fall-out-or-false-positive-rate)" style="text-decoration:None;">FPR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Fall-out or false positive rate</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#G-(G-measure-geometric-mean-of-precision-and-sensitivity)" style="text-decoration:None;">G</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.86603</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">G-measure geometric mean of precision and sensitivity</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#PLR-(Positive-likelihood-ratio)" style="text-decoration:None;">LR+</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Positive likelihood ratio</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#NLR-(Negative-likelihood-ratio)" style="text-decoration:None;">LR-</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Negative likelihood ratio</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#MCC-(Matthews-correlation-coefficient)" style="text-decoration:None;">MCC</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Matthews correlation coefficient</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#MK-(Markedness)" style="text-decoration:None;">MK</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Markedness</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#N-(Condition-negative)" style="text-decoration:None;">N</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">3</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Condition negative</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#NPV-(negative-predictive-value)" style="text-decoration:None;">NPV</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.75</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Negative predictive value</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#P-(Condition-positive)" style="text-decoration:None;">P</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">3</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Condition positive</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#POP-(Population)" style="text-decoration:None;">POP</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">4</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">4</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Population</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#PPV-(precision-or-positive-predictive-value)" style="text-decoration:None;">PPV</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.75</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">None</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Precision or positive predictive value</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#PRE-(Prevalence)" style="text-decoration:None;">PRE</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.75</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.25</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Prevalence</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#RACC(Random-accuracy)" style="text-decoration:None;">RACC</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.75</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Random accuracy</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#RACCU(Random-accuracy-unbiased)" style="text-decoration:None;">RACCU</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.76562</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.01562</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Random accuracy unbiased</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TN-(True-negative/correct-rejection)" style="text-decoration:None;">TN</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">3</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">True negative/correct rejection</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TNR-(specificity-or-true-negative-rate)" style="text-decoration:None;">TNR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Specificity or true negative rate</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TON-(Test-outcome-negative)" style="text-decoration:None;">TON</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">4</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Test outcome negative</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TOP-(Test-outcome-positive)" style="text-decoration:None;">TOP</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">4</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Test outcome positive</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TP-(True-positive-/-hit)" style="text-decoration:None;">TP</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">3</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">True positive/hit</td>
</tr>
<tr align="center" style="border:1px solid black;border-collapse: collapse;">
<td style="border:1px solid black;padding:4px;border-collapse: collapse;"><a href="http://www.shaghighi.ir/pycm/doc/index.html#TPR--(sensitivity,-recall,-hit-rate,-or-true-positive-rate)" style="text-decoration:None;">TPR</a></td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">1.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;">0.0</td>
<td style="border:1px solid black;padding:4px;border-collapse: collapse;text-align:left;">Sensitivity, recall, hit rate, or true positive rate</td>
</tr>
</table>
