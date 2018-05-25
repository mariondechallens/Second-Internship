z<-tail(sort(rnorm(1e6)),500)
z1<-tail(sort(rlnorm(1e6)),500)
z2<-tail(sort(rexp(1e6)),500)
z3<-tail(sort(rf(1e6,df1=5,df2=10)),500)
p<-seq(500,1)/1e6

par(mfrow=c(2,2))

plot(log(z),log(-log(p)),col="red",main="Normal(0,1)",ylim=c(2,3))
axis(4,at=c(2,3),labels=c(paste0("p=",1e-2),paste0("p=",1e-3)))

plot(log(z1),log(-log(p)),col="red",main="Log-Normal(0,1)",ylim=c(2,3))
axis(4,at=c(2,3),labels=c(paste0("p=",1e-2),paste0("p=",1e-3)))

plot(log(z2),log(-log(p)),col="red",main="Exp(lambda = 1)",ylim=c(2,3))
axis(4,at=c(2,3),labels=c(paste0("p=",1e-2),paste0("p=",1e-3)))

plot(log(z3),log(-log(p)),col="red",main="Fisher(5,10)",ylim=c(2,3))
axis(4,at=c(2,3),labels=c(paste0("p=",1e-2),paste0("p=",1e-3)))
     