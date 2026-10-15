library(ggplot2)

make_dot_plot<-function(SR){
  #We only shown pre-identified genes
  SR[!is.na(SR$ImpSet),]->SR
  SR[SR$ImpSet%in%c("Known","Candidate"),]->SR
  SR$ImpSet<-factor(as.character(SR$ImpSet),levels=c("Known","Candidate"))

  #FDR classes
  SR$FDR<-cut(
    SR$BFDR,
    c(0,0.01,0.05,Inf),
    labels=c("<0.01","<0.05",">0.05"),
    include.lowest=TRUE
  )

  #We only show FDR < 5%
  SR[SR$BFDR<0.05,]->SR

  #Plot structure
  ggplot(SR,aes(
      y=ImpGeneName,
      x=Bait,
      size=PreyMass,
      fill=SaintScore,
      color=FDR
    ))+
    geom_point(shape=21,stroke=1.1)+
    scale_color_manual(values=c("red","#015ae1","green"))+ #"#FFEEEE"))+
    scale_fill_gradient(low="white",high="black")+
    facet_grid(ImpSet~.,scales="free_y")+ylab("Prey")
}

if(!interactive()){
  commandArgs(TRUE)->args
  stopifnot(length(args)==4)
  readRDS(args[1])->saint_result
  make_dot_plot(saint_result)->plot
  ggsave(
    args[2],
    plot,
    width=as.numeric(args[3]),
    height=as.numeric(args[4])
  )
}
