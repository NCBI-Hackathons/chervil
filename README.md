# CHERVIL

Computational Human Endogenous RetroViral Infection Labeler (CHERVIL) is a pipeline for the detection of endogenous retroviral expression patterns that correspond to current or previous viral infection.


![ERV](images/ERV.png)


## What is CHERVIL and why do we need it?
Human endogenous retroviral elements (HERVs) are retroviruses that have integrated themselves into the human germline. Usually, they remain latent in the human genome. However, previous work suggests that some HERVs become actively transcribed upon viral infection. CHERVIL uses differential expression analysis of HERVs in healthy and infected populations via RNA-seq in  to detect pre-symptomatic or historic viral infection.

CHERVIL builds on an existing pipeline built for HERV detection [RetroSpotter](https://github.com/NCBI-Hackathons/RetroSpotter) and adds on a machine learning component to identify patterns in HERV expression specific to distinct viral infections.

## How it works

![pipeline](images/pipeline.png)

At a high level, there are two major phases of the CHIRVEL pipeline.

The first is the calculation of HERV expression in different populations. To do this, we use RetroSpotter and Magic-BLAST to align RNA-seq data to known HERVs to quantify HERV expression.

The second phase is the automatic development of a machine learning pipeline that uses expression data to predict disease status. We accomplish this using [TPOT](https://github.com/EpistasisLab/tpot) to identify HERV expression patterns specific to viral infection.

## How to use CHERVIL

1. Input .csv file with two columns: accession numbers and their classifications.
```csv
SRR123456, infected
SRR789101, infected
SRR112131, infected
SRR415161, control
SRR718192, control
SRR021222, control
```
(note: these are made-up accessions)

2. Simple one line command to generate HERV count data

This command calls multiple scripts that execute the pipeline we have developed. \
    a. RetroSpotter github repo is cloned \
    b. call the RetroSpotter script makeblastdb.sh to create a blast database of the human endogenous retroviruses \
    c. this is all taken care of using a reference FASTA file from RetroSpotter \
    d. call the RetroSpotter script run_jobs.sh which uses the magicblast command to align RNA-seq reads to the reference blast database \
    e. call the RetroSpotter script count_hits.sh which takes the sam files output from the run_jobs.sh script and counts the number of reads corresponding to each ERV gene \
    f. organize the counts into a dataframe that includes all of the sample numbers (by SRR accession), their class (infected, not infected, etc.) and their read count for each ERV gene, written to a csv file \
    g. feed this dataframe into our machine learning algorithm for class detection \

3. Other use info here?

## Installation
### Requirements

Before proceeding, ensure that you have the following installed and functional:

1. [R 3.5 or greater](https://cran.r-project.org)
2. [Python 3.6 or greater](https://www.python.org/downloads/release/python-365/)
3. [Magic-BLAST](https://ncbi.github.io/magicblast/)
4. [A towel](https://en.wikipedia.org/wiki/Towel_Day#Origin)

### Instructions

First, clone a copy of the repository:

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

## Example Run
### Example Dataset
* PRJNA349748: Human Tracheobronchial Epithelial (HTBE) cells infected with Influenza
    + Data Type: RNA-seq
    + Conditions / Samples: H1N1, H5N1, H3N2, mock-infected controls
