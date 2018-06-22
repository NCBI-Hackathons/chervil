#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

influ <- read.csv(args[1])
write.table(influ[, 1], file = "temp_acc.txt")