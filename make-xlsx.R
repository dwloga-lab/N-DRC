library(openxlsx)

if(!interactive()){
  commandArgs(TRUE)->file
  stopifnot(length(file)==2)
  write.xlsx(readRDS(file[1]),file[2])
}
