Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")

vect<-c(0.1,0.2,0.3,0.33,0.37,0.4,0.41,0.44,0.48,0.5,0.52,0.54,0.56,0.6,0.65,0.7)
result<-data.frame(matrix(nrow=length(vect),ncol=4))
colnames(result)<-c("Mean","True.p","IS","IS.t.test")
result$Mean<-vect


for (i in 1:length(vect)) 
{
  # l'exemple de EXPERT
  set.seed(1)
  x <- rnorm(200, mean=0, sd=1)
  y <- rnorm(200, mean=vect[i], sd=1)
  z <- c(x,y)
  L0 <- c(rep(1L,200),rep(2L,200))

  # la matrice de distances entre tous les elts de z
  DIST <- outer(z, z, function(a,b) abs(a-b) )

  # exemples
  par(mfrow=c(1,4))
  boxplot(z ~ L0)
  L <- L0; L[1] <- L[1] + 0L # force copie
  k <- c(length(x), length(y))
  IS(k, DIST, L, 0); boxplot(z ~ L)
  IS(k, DIST, L, 1); boxplot(z ~ L)
  IS(k, DIST, L, 3); boxplot(z ~ L)

  #  F <- function(z, L) abs(t.test(z ~ L, var.equal = TRUE)$statistic)
  F <- function(z, L) abs(t_test(z, L))

  t.obs <- F(z, L0);
  # True p-value
  result[i,2]<- 2.0*(1-pt(t.obs, df=length(z)- 2))


  result[i,3]<-Run_IS(F, z, L0, DIST, 1e5, 0.8, 2)$p
  result[i,4]<-Run_IS_t_test(z, L0, DIST, 1e5, 0.8, 2)$p

}

View(result)
write.csv2(result,file="C:/Users/Marion/Documents/Stage/Importance Sampling/test_IS.csv",row.names=FALSE)

plot(result$Mean,-log(result$True.p),col="red",type="l")
lines(result$Mean,-log(result$IS.t.test),col="blue")


#### proba empirique avec importance sampling

pvalue<-list(zero=rep(0,500),zero5=rep(0,500),un=rep(0,500))
tobs<-c(1:500)*0.01
theta<-c(0,0.5,1)

for (i in 1:length(theta))
{
  set.seed(1)
  x <- rnorm(200, mean=0, sd=1)
  y <- rnorm(200, mean=0.5, sd=1)
  z <- c(x,y)
  L0 <- c(rep(1L,200),rep(2L,200))
  
  # la matrice de distances entre tous les elts de z
  DIST <- outer(z, z, function(a,b) abs(a-b) )
  L <- L0; L[1] <- L[1] + 0L # force copie
  k <- c(length(x), length(y))
  
  B <- 10000;
  w <- numeric(B)
  t.perm <- numeric(B)
  for(n in 1:B) {
    w[n] <- IS(k, DIST, L, theta[i]); 
    t.perm[n] <- t_test(z , L)
  }
  
  #On modifie les poids pour que la somme fasse 1 :
  w <- w / sum(w)
  
  for (j in 1:length(tobs))
  {
    pvalue[[i]][j]<-sum( w*(t.perm < tobs[j]) )
  }
  
}

plot(tobs,pvalue$zero,type="l")
lines(tobs,pvalue$zero5,col="blue")
lines(tobs,pvalue$un,col="forestgreen")
lines(tobs,pnorm(tobs),col="red")
legend("bottomright",
       legend=c("theta = 0","theta = 0.5","theta = 1", "Vraie distribution"),
       fill=c("black","blue","forestgreen","red"))




# Tr <- replicate(1e4, { IS(k, DIST, L, 0.5); t_test(z, L) } )
# hist(Tr)
