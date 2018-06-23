#!/usr/bin/env bash

display_usage() { 
	echo
	echo "Quantify read counts for ERV elements in a blast database."
	echo "Then build classifier predicting patient infection status" 
	echo -e "\nUsage: chervil.sh [path to SRR acession file] [path to blast database] [number of cores] [output directory] [prefix for sam files] \n" 
	}

if [ -z "$1" ]
  then
    display_usage
    exit 1
fi

if [ -z "$2" ]
  then
    display_usage
    exit 1
fi


if [ -z "$3" ]
  then
    display_usage
    exit 1
fi

if [ -z "$4" ]
  then
    display_usage
    exit 1
fi

if [ -z "$5" ]
  then
    display_usage
    exit 1
fi

ACC_FILE=$1 #File containg SRR accession numbers
BLAST_DB=$2 #Blast database
THREADS=$3 #Number of magic blast threads to use
OUT_DIR=$4 #Where to put the results when job in run
LABEL=$5 #Short label for file name


S1_make_acc_file.r $ACC_FILE
run_jobs.sh temp_acc.txt $BLAST_DB $THREADS $OUT_DIR $LABEL
rm temp_acc.txt 
count_hits.sh $OUT_DIR
S2_orgCountsScript.r $ACC_FILE $OUT_DIR 
S3_generate_classifier.py ERVcounts_comp.csv
