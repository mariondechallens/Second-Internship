library(CEoptim)

z<-list(tail(sort(rnorm(1e6)),500))
p<-list(seq(500,1)/1e6)
zobs<-6
pnorm(zobs,lower.tail=F)
#qexp(3.05e-07,lower.tail=F)

obs<-function(x) {
  if (x<=6)
    pnorm(x,lower.tail = F)
  else
    pnorm(x)
}
pvalue<-CEoptim(f=obs,rho=0.01,discrete = list(probs=p),N=1e6) #minimiser 
#CEoptim(f=obs,rho=0.01,continuous = list(mean = mean(z[[1]]),sd=sd(z[[1]])),N=1e6) #minimiser 

load("C:/Users/Marion/Documents/Stage/packageBC/FST_1.RData")

resultCE<-data.frame(matrix(nrow=3,ncol=2))
colnames(resultCE)<-c("Genes","CE pvalue")
resultCE$Genes<-names(FST.1)

for (i in 1:length(FST.1)){
  gene<-c(rep(min(FST.1[[i]]-1),1e6-500),FST.1[[i]]) 
  #the observed test stat is the 501th value of gene
  #the 500 first are the test statistics got by permutations
  dens<-function(x) {
    if (x<=gene[501])
      mean(rev(cumsum(rev(density(gene[1:1e6])$y[13:512]))))
    else
      mean(cumsum(density(gene[1:1e6])$y[13:512]))
      
  }
  resultCE[i,2]<-CEoptim(f=dens,rho=0.01,discrete = list(probs=p),N=1e6)$optimum
  
}
