Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_continu.cpp")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")

# exemple
n<-1e4
true.p<-rep(0,n)
est.p<-rep(0,n)
est.p2<-rep(0,n)

for (j in 1:n)
{
  set.seed(1)
  x <- rnorm(400)
  y <- rnorm(400) + 0.2*x
  
  
  obs <- cor(x,y);
  true.p[j]<-cor.test(x,y)$p.value  
  
  # permutations "classiques"
  # perm0 <- replicate(10000, { y1 <- sample(y); cor(x,y1) } )
  # 
  # mean( abs(perm0) > abs(obs) )  # oups 0
  # 
  #### importance sampling (avec theta qui augmente à chaque itération)
  DIST <- outer(x, x, function(a,b) abs(a-b) )
  L <- integer(length(x))
  B <- 1e4
  w <- numeric(B)
  perm <- numeric(B)
  theta <- seq(0,2.5,length=B)
  y1 <- sort(y)
  for(i in 1:B) {
    w[i] <- IS_c(DIST, L, theta[i])
    perm[i] <- cor(x, y1[L])
  }
  
  est.p[j]<-sum( w*(abs(perm) > abs(obs)) )/sum(w) 
  

### Importance sampling en continu
ng<-sqrt(length(DIST))/5

z <- c(x,y)
zsort <- list(z1 = sort(z)[1:ng], z2 = sort(z)[(ng+1):(2*ng)], z3 = sort(z)[(2*ng+1) : (3*ng)], z4 =sort(z)[(3*ng +1) : (4*ng)], z5 = sort(z) [(4*ng+1) : (5*ng)])

L0 <- c(rep(1L,sqrt(length(DIST))/5),rep(2L,sqrt(length(DIST))/5),rep(3L,sqrt(length(DIST))/5),rep(4L,sqrt(length(DIST))/5),rep(5L,sqrt(length(DIST))/5))


L <- L0; L[1] <- L[1] + 0L # force copie
k <- c(sqrt(length(DIST))/5, sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5)

B <- 1e4
w <- numeric(B)
t.perm <- numeric(B)
for(i in 1:B) {
  w[i] <- IS(k, DIST, L, 0.5); #theta = 0.5
  y<-resamp(L,zsort)
  t.perm[i] <-t_test(y , L)
}


#On modifie les poids pour que la somme fasse 1 :
w <- w / sum(w)

est.p2[j]<-sum( w*(abs(t.perm) > abs(obs)) )/sum(w) 

}

plot(log10(est.p),col="blue",main=paste0(n," iterations."))
plot(log10(est.p2), col="forestgreen")
lines(log10(true.p),col="red")
legend("topright",
       legend=c("Estimated p H","Estimated p M", "True p"), 
       fill = c("blue", "forestgreen", "red"))


