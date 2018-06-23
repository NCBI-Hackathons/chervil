#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

influ <- read.csv(args[1], header = F)
write.table(influ[, 1], file = "temp_acc.txt", row.names = F, col.names = F, quote = F)
