library(pkgload)
load_all("vendored/saintexpress")

readRDS('data/meta.RDS')->M
readRDS('data/prey-mass.RDS')->PM


process<-function(input){
  #Meta-data
  M$important->Imp
  Imp$Protein->rownames(Imp)
  run_saint(input)->SR
  factor(
    as.character(Imp[SR$Prey,"GeneName"]),
    levels=rev(unique(Imp$GeneName))
  )->SR$ImpGeneName
  Imp[SR$Prey,"Set"]->SR$ImpSet
  PM[SR$Prey]->SR$PreyMass
  #We remove Tt9030 since it is a low-confidence detection
  SR[ifelse(!is.na(SR$ImpGeneName),as.character(SR$ImpGeneName),"")!="Tt9030",]->SR
  SR
}

if(!interactive()){
  commandArgs(TRUE)->file
  stopifnot(length(file)==2)
  readRDS(file[1])->input
  process(input)->output
  saveRDS(output,file[2])
}

