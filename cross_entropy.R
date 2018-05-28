##package CEoptim and RCEIM

library(CEoptim)
library(RCEIM)
#library(EnvStats) #pemp liste de valeurs pas fonction

z<-list(tail(sort(rlnorm(1e6)),500))
p<-list(seq(500,1)/1e6)
zobs<-150
plnorm(zobs,lower.tail=F)
#qexp(3.05e-07,lower.tail=F)

obs<-function(x) {
  if (x<=150)
    plnorm(x,lower.tail = F)
  else
    plnorm(x)
}
pvalue<-CEoptim(f=obs,rho=0.01,discrete = list(probs=p),N=1e6)$optimum #minimiser 
#CEoptim(f=obs,rho=0.01,continuous = list(mean = mean(z[[1]]),sd=sd(z[[1]])),N=1e6) #minimiser 
ceimOpt(OptimFunction = obs,Ntot=1e5)$BestMember

load("C:/Users/Marion/Documents/Stage/packageBC/FST_1.RData")

resultCE<-data.frame(matrix(nrow=3,ncol=3))
colnames(resultCE)<-c("Genes","CE pvalue1","CE pvalue2")
resultCE$Genes<-names(FST.1)

for (i in 1:length(FST.1)){
  gene<-FST.1[[i]]
  #the observed test stat is the 501th value of gene
  #the 500 first are the test statistics got by permutations
  distr<-function(x) { #fonction de distribution empiriquex, liste de 500 valeurs
    if (x<=gene[501])
      1 - ecdf(gene[1:500])(x)
    else
      ecdf(gene[1:500])(x)
  } 
  resultCE[i,2]<-CEoptim(f=distr,rho=0.01,discrete = list(probs=p),N=10000)$optimum
  #resultCE[i,3]<-ceimOpt(OptimFunction = distr)$BestMember # bug

}
