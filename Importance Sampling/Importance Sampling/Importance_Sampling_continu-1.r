Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_continu.cpp")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")

resamp <- function(L,y) # y liste de listes, L liste de labels
{
  nLab<-length(y)
  if (nLab > 0)
  {
    yR<-L
    for (l in 1:nLab)
    {
      yR[yR == l] <- sample(y[[l]],length(y[[l]]))
    }
    return (yR)
  }
  return(0)
}

n<-seq(0.15,0.3,by=0.002)
true.p<-rep(0,length(n))
est.p<-rep(0,length(n))
pvalueM<-rep(0,length(n))
pvaluenorm<-rep(0,length(n))

for (j in 1:length(n))
{
  print(j)
  set.seed(1)
  x <- rnorm(400)
  y <- rnorm(400) + n[j]*x
  
  DIST <- outer(x, x, function(a,b) abs(a-b) )
  obs <- cor(x,y)
  true.p[j]<-cor.test(x,y)$p.value  
  
  # permutations "classiques"
  # perm0 <- replicate(10000, { y1 <- sample(y); cor(x,y1) } )
  # 
  # mean( abs(perm0) > abs(obs) )  # oups 0
  # 
  #### importance sampling (avec theta qui augmente à chaque itération)
  
  L <- integer(length(x))
  B <- 1e5
  w <- numeric(B)
  perm <- numeric(B)
  #theta <- seq(0,2.5,length=B)
  theta <- rep(0,length(B))
  y1 <- sort(y)
  for(i in 1:B) {
    w[i] <- IS_c(DIST, L, theta[i])
    perm[i] <- cor(x, y1[L])
  }
  plot(log10(w))
  est.p[j]<-sum( w*(abs(perm) > abs(obs)) )/sum(w)

  ##methode marion
  # ng<-sqrt(length(DIST))/5
  # zsort <- list(z1 = sort(y)[1:ng], z2 = sort(y)[(ng+1):(2*ng)], z3 = sort(y)[(2*ng+1) : (3*ng)], z4 =sort(y)[(3*ng +1) : (4*ng)], z5 = sort(y) [(4*ng+1) : (5*ng)])
  # L0 <- c(rep(1L,sqrt(length(DIST))/5),rep(2L,sqrt(length(DIST))/5),rep(3L,sqrt(length(DIST))/5),rep(4L,sqrt(length(DIST))/5),rep(5L,sqrt(length(DIST))/5))
  # #plot(L0)
  # 
  # L <- L0; L[1] <- L[1] + 0L # force copie
  # k <- c(sqrt(length(DIST))/5, sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5)
  # 
  # # List<-list(L0)
  # # Listy<-list(y)
  # B <- 1e5
  # w <- numeric(B)
  # t.perm <- numeric(B)
  # for(i in 1:B) {
  #   w[i] <- IS(k, DIST, L, 0.03);
  #   y<-resamp(L,zsort)
  #   # Listy<-c(Listy,list(y))
  #   # L1<-L; L1[1] <- L1[1] + 0L
  #   # List<-c(List,list(L1))
  #   t.perm[i] <-  cor(x,y)
  # }
  # 
  # w <- w / sum(w)
  # plot(log10(w))
  # pvalueM[j]<-sum( w*(abs(t.perm)  > abs(obs)) )
  
  ##sampling normal
  B <- 1e6
  w <- numeric(B)
  t.perm2 <- numeric(B)
  for(i in 1:B) {
    w[i] <- 1
    y<-sample(y)
    t.perm2[i] <-  cor(x,y)
  }

  w <- w / sum(w)
  pvaluenorm[j]<-sum( w*(abs(t.perm2)  > abs(obs)) )
  

}

jpeg("C:/Users/Marion/Documents/Stage/Importance Sampling/Plots/theta0ISc",res = 450, height = 12, width = 16, units = 'cm')
#plot(n,log10(est.p),col="blue",type="l",main="Continu et correlations")
plot(n,log10(true.p),col="red",main = "theta = 0 IS-continu",type="l")
lines(n,log10(est.p),col="black")
lines(n,log10(pvaluenorm),col="forestgreen")
# legend("topright",
#        legend=c("Estimated p H", "True p","Estimated p M","Normal sampling"), 
#        fill = c("blue", "red"," black", "forestgreen"))

legend("topright",
       legend=c( "True p","Estimated p H","Normal sampling"),
       fill = c("red"," black", "forestgreen"))
dev.off()