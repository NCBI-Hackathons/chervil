
###### retrieve the SRR numbers and the class ids text file
classids_path="C:/Users/gvagl/Dropbox/GradSchool/IQBioProgram/RMGHC/classids.txt" #path to a tab-delimited file with SRR and class id
classids = data.frame(read.table(file=classids_path, sep = "\t"), stringsAsFactors = FALSE)
colnames(classids) <- c("SRR", "class")


###### gather all of the counts data into a single data.frame
sam_dir = "C:/Users/gvagl/Dropbox/GradSchool/IQBioProgram/RMGHC/" # this is the directory that stores the sam.hitcount.txt files

for(f in 1:nrow(classids)){
  
  if(exists("allhits")){
    fname = paste0(sam_dir, as.character(classids$SRR[f]), ".sam.hitcount.txt")
    newhits = data.frame(read.table(file=fname, sep=" "))
    allhits = merge(allhits, newhits, all=TRUE, by = "V2")
    rm(newhits, fname)
  }  else {
    fname = paste0(sam_dir, as.character(classids$SRR[f]), ".sam.hitcount.txt")
    allhits = data.frame(read.table(file=fname, sep=" "))
    rm(fname)
  }
  
}
# rename the columns to reflect the SRR sample
colnames(allhits) <- c("ERV", as.character(classids$SRR))




###### create columns in classids for each ERV
ervs = as.character(allhits$ERV)
for(i in 1:length(ervs)){
  classids[[ervs[i]]] = NA
}



###### fill classids with counts for each ERV
for(srr in 1:nrow(classids)){
  ind = as.character(classids$SRR[srr])
  classids[srr,3:ncol(classids)] = allhits[[ind]]
  rm(ind)
}
