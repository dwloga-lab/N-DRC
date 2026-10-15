readRDS('data/meta.RDS')->M
readRDS('data/prey-mass.RDS')->PM

make_graph<-function(SR,only_v_imp=TRUE,fdr_th=Inf,cycle=TRUE,fn){
  G<-SR
  G[,c("Bait","ImpGeneName","ImpSet","PreyMass","SaintScore","BFDR")]->G
  G[!is.na(G$ImpGeneName),]->G
  names(G)[2]<-"Prey"
  if(!cycle) G[G$Prey!=G$Bait,]->G
  if(only_v_imp) G[G$ImpSet%in%c("Known","Candidate"),]->G

  G[G$BFDR<fdr_th,]->G
  edg<-sprintf("\t%s -> %s [penwidth=%0.2f];",G$Bait,G$Prey,0.5+G$SaintScore*3)
  
  #All baits are preys, except of Tt2740, which we add manually
  V<-rbind(data.frame(Gene=G$Prey,Mass=G$PreyMass),data.frame(Gene="Tt2740",Mass=PM["TTHERM_00102740"]))
  V<-unique(V)
  setNames(M$important$Colour,M$important$GeneName)[as.character(V$Gene)]->V$Color
  V$Color[is.na(V$Color)]<-"red"
  V$ViSize<-((log(V$Mass)-log(min(V$Mass)))/6)
  vtx<-sprintf("\t %s [shape=circle;width=%0.2f;height=%0.2f;style=\"filled\";fillcolor=\"#%s\"];",V$Gene,V$ViSize,V$ViSize,V$Color)
  if(!missing(fn))
    writeLines(c("digraph {","\t overlap=prism;","\t splines=true;",vtx,edg,"}"),fn)
  G
}

if(!interactive()){
  commandArgs(TRUE)->args
  stopifnot(length(args)==2)
  readRDS(args[1])->saint_result
  #FDR < 5% edges ONLY, no cycles
  invisible(make_graph(saint_result,fdr_th=0.05,cycle=FALSE,fn=args[2]))
}

