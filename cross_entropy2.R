library(EXPERT)

load("C:/Users/Marion/Documents/Stage/packageBC/FST_1.RData")
data<-FST.1[[1]][1:500]
zobs<- FST.1[[1]][501]

z<-list(tail(sort(rnorm(1e6)),500))
zobs<-5.1
pnorm(zobs,lower.tail=F)
qnorm(pnorm(zobs,lower.tail=F),lower.tail=F)

ttest<-function (data.input) 
{
  abs(t.test(data.input)$statistic[[1]])
}

permut<- function (data.input, prop.change) 
{
  xchange<-sample(1:length(data.input),prop.change*length(data.input))
  c(data.input[-xchange],data.input[xchange])
}

SAMC.adapt(data.input=tail(sort(rnorm(1e6)),500),
           t.obs=5.1,
           fun.test.statistic=ttest, 
           fun.proposal=permut)
