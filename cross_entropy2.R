library(EXPERT)
library(gaston)
library(oz)

load("C:/Users/Marion/Documents/Stage/packageBC/FST_1.RData")
x<-read.bed.matrix("C:/Users/Marion/Documents/Stage/1KG_eur_maf1pm_genes")
data<-list(x=x, group = x@ped$population, genomic.region = x@snps$gene)


teststat<-function (data.input) #liste des para de Sum.Fst (x, group, region)
{
  FST<-Sum.Fst(data.input$x, group = data.input$group, genomic.region = data.input$genomic.region,B.max=0)
  return(FST$statistic)
}

permut<- function (data.input, prop.change) 
{
  n<-length(data.input$group)
  m<-floor(n*prop.change)
  I<-sample(1:n,m)
  data.input$group[I]<-sample(data.input$group[I])
  
}


res<-SAMC.adapt(data.input=data,
           t.obs=teststat(data),
           fun.test.statistic=teststat, 
           fun.proposal=permut)

