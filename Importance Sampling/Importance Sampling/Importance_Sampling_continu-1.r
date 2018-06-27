Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_continu.cpp")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")

k2dM<-function (Mat, direction = "k2d", method = "norm", scale = 1, 
                pos = TRUE) 
{
  if (direction == "k2d") {
    num <- nrow(Mat)
    index <- 1:num
    comb.index <- combn(index, 2)
    myD <- Mat - Mat
    if (method == "norm") {
      apply(comb.index, 2, FUN = function(x) {
        valxx <- Mat[x[1], x[1]]
        valxy <- Mat[x[1], x[2]]
        valyy <- Mat[x[2], x[2]]
        myD[x[1], x[2]] <<- myD[x[2], x[1]] <<- sqrt((valxx - 
                                                        2 * valxy + valyy)^2)
      })
      diag(myD) <- 0
    }
    else if (method == "CS") {
      apply(comb.index, 2, FUN = function(x) {
        valxx <- Mat[x[1], x[1]]
        valxy <- Mat[x[1], x[2]]
        valyy <- Mat[x[2], x[2]]
        myD[x[1], x[2]] <<- myD[x[2], x[1]] <<- acos(valxy^2/(valxx * 
                                                                valyy))
      })
      diag(myD) <- 0
    }
    else if (method == "exp") {
      apply(comb.index, 2, FUN = function(x) {
        valxx <- Mat[x[1], x[1]]
        valxy <- Mat[x[1], x[2]]
        valyy <- Mat[x[2], x[2]]
        myD[x[1], x[2]] <<- myD[x[2], x[1]] <<- exp(-valxy/scale)
      })
      diag(myD) <- 0
    }
    else if (method == "naive") {
      apply(comb.index, 2, FUN = function(x) {
        valxx <- Mat[x[1], x[1]]
        valxy <- Mat[x[1], x[2]]
        valyy <- Mat[x[2], x[2]]
        myD[x[1], x[2]] <<- myD[x[2], x[1]] <<- 1 - valxy/sqrt(valxx * 
                                                                 valyy)
      })
      diag(myD) <- 0
    }
    else {
    }
    myD[which(is.na(myD))] <- max(myD, na.rm = TRUE)
    return(myD)
  }
  else {
    num <- nrow(Mat)
    index <- 1:num
    comb.index <- combn(index, 2)
    if (method == "DC") {
      myK <- Mat - Mat
      apply(comb.index, 2, FUN = function(x) {
        myK[x[1], x[2]] <<- myK[x[2], x[1]] <<- (-Mat[x[1], 
                                                      x[2]] + sum(Mat[, x[2]])/num + sum(Mat[, x[1]])/num - 
                                                   sum(Mat)/(num^2))/2
      })
      Mat <- myK
      rm(myK)
    }
    else if (method == "exp") {
      myK <- Mat - Mat
      apply(comb.index, 2, FUN = function(x) {
        valxx <- Mat[x[1], x[1]]
        valxy <- Mat[x[1], x[2]]
        valyy <- Mat[x[2], x[2]]
        myK[x[1], x[2]] <<- myK[x[2], x[1]] <<- exp(-valxy/scale)  #myK au lieu de myD
      })
      Mat <- myK
      rm(myK)
    }
    else {
    }
    if (pos) {
      eig <- eigen(Mat)
      eig$values[eig$values < 0] <- 10^(-8)
      myK <- eig$vectors %*% diag(eig$values, length(eig$values)) %*% 
        t(eig$vectors)
      myK <- 0.5 * (myK + t(myK))
      return(myK)
    }
    return(myK)
  }
}

### tests methode Herve
n<-seq(0.1,0.3,by=0.01)
true.p<-rep(0,length(n))
est.p<-rep(0,length(n))

for (j in 1:length(n))
{
  print(n)
  set.seed(1)
  x <- rnorm(400)
  y <- rnorm(400) + n[j]*x
  
  
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
  

}
plot(log10(est.p),col="blue",main=paste0(n," iterations."))
lines(log10(true.p),col="red")
legend("topright",
       legend=c("Estimated p", "True p"), 
       fill = c("blue", "red"))


###tests methode marion
#est.pM<-rep(0,length(n))
set.seed(1)
x <- rnorm(400)
y <- rnorm(400) + 0.2*x
z <- c(x,y)
meanZ<-mean(z)
DIST <- outer(z, z, function(a,b) abs(a-b) )
K<- k2dM(DIST,direction = "d2k",method = "exp", scale=1)

ng<-sqrt(length(DIST))/5
varZ<-var(z)
zsort <- list(z1 = sort(z)[1:ng], z2 = sort(z)[(ng+1):(2*ng)], z3 = sort(z)[(2*ng+1) : (3*ng)], z4 =sort(z)[(3*ng +1) : (4*ng)], z5 = sort(z) [(4*ng+1) : (5*ng)])


zobs <- t(z - meanZ) %*% K %*% (z -meanZ)
L0 <- c(rep(1L,sqrt(length(DIST))/5),rep(2L,sqrt(length(DIST))/5),rep(3L,sqrt(length(DIST))/5),rep(4L,sqrt(length(DIST))/5),rep(5L,sqrt(length(DIST))/5))


L <- L0; L[1] <- L[1] + 0L # force copie
k <- c(sqrt(length(DIST))/5, sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5)


B <- 1e4
w <- numeric(B)
t.perm <- numeric(B)
for(n in 1:B) {
  w[n] <- IS(k, DIST, L, 1);
  y<-resamp(L,zsort)
  t.perm[n] <-  (y - meanZ) %*% K %*% (y -meanZ)/varZ
}


#On modifie les poids pour que la somme fasse 1 :
w <- w / sum(w)

est.pM<-sum( w*(t.perm  > zobs[1,1]) )

