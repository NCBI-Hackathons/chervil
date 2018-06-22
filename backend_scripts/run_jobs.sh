#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No argument supplied"
    exit 1
fi


if [ -z "$3" ]
  then
    echo "No argument supplied"
    exit 1
fi

if [ -z "$4" ]
  then
    echo "No argument supplied"
    exit 1
fi

if [ -z "$5" ]
  then
    echo "No argument supplied"
    exit 1
fi


ACC_FILE=$1 #File containg SRR accession numbers
BLAST_DB=$2 #Blast database
THREADS=$3 #Number of magic blast threads to use
OUT_DIR=$4 #Where to put the results when job in run
COMMENT=$5 #Short comment for file name

mkdir $OUT_DIR


# run jobs
for i in $( cat $ACC_FILE ); do

  echo $i

  magicblast -db $BLAST_DB -sra $i -no_unaligned -num_threads $THREADS -out $OUT_DIR/$COMMENT.$i.sam

done
