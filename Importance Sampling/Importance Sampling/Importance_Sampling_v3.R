Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")
library(mmpp)

# Torgerson formula (Double centering) with mmpp package
# Kernel and distance matrix

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

## Tests 

for (B in c(1e4,1e5,1e6))
{
  tobs<- seq(0, 10, by=0.01)
  pvalue<-list(outer=rep(0,length((tobs))),exp=rep(0,length(tobs)),dc=rep(0,length(tobs)))
  
  
  set.seed(1)
  x <- rnorm(200, mean=0, sd=1)
  y <- rnorm(200, mean=0.5, sd=1)
  z <- c(x,y)
  L0 <- c(rep(1L,200),rep(2L,200))
  
  # la matrice de distances entre tous les elts de z
  DIST <- outer(z, z, function(a,b) abs(a-b) )
  
  # exemples
  L <- L0; L[1] <- L[1] + 0L # force copie
  k <- c(length(x), length(y))
  
  #B <- 1000000
  w <- numeric(B)
  t.perm <- numeric(B)
  for(n in 1:B) {
    w[n] <- IS(k, DIST, L, 0.5); 
    t.perm[n] <- t_test(z , L)
  }
  
  #On modifie les poids pour que la somme fasse 1 :
  w <- w / sum(w)
  
  for (j in 1:length(tobs))
  {
    pvalue$outer[j]<-sum( w*(t.perm  > tobs[j]) )
  }
  
  ## Distance matrix with exponential Kernel 
  theta<-0.5
  Ke<-k2dM(DIST,direction="d2k",method="exp",scale=1/theta)
  DISTe<-log(Ke)*(-1/theta)
  
  w <- numeric(B)
  for(n in 1:B) {
    w[n] <- IS(k, DISTe, L, 0.5); 
    t.perm[n] <- t_test(z , L)
  }
  
  #On modifie les poids pour que la somme fasse 1 :
  w <- w / sum(w)
  
  for (j in 1:length(tobs))
  {
    pvalue$exp[j]<-sum( w*(t.perm  > tobs[j]) )
  }
  
  ## Distance matrix with DC Kernel 
  Kdc<-k2dM(DIST,direction="d2k",method="DC")
  DISTdc<-DIST-DIST
  c<-0
  for (i in 1:nrow(DIST))
  {
    for (j in 1:nrow(DIST))
    {
      if (Kdc[i,i] + Kdc[j,j] - 2*Kdc[i,j] < 0)
      {
        DISTdc[i,j] <- 0
        c<-c+1
      }
      
      else
        DISTdc[i,j] <- sqrt(Kdc[i,i] + Kdc[j,j] - 2*Kdc[i,j])
    }
  }
  print(paste0("nan = ",c))
  w <- numeric(B)
  for(n in 1:B) {
    w[n] <- IS(k, DISTdc, L, 0.5); 
    t.perm[n] <- t_test(z , L)
  }
  
  #On modifie les poids pour que la somme fasse 1 :
  w <- w / sum(w)
  
  for (j in 1:length(tobs))
  {
    pvalue$dc[j]<-sum( w*(t.perm  > tobs[j]) )
  }
  
  jpeg(paste0("C:/Users/Marion/Documents/Stage/Importance Sampling/Plots/Kernel/Importance Sampling with kernel and ",B," permutations.jpeg"),res = 450, height = 12, width = 16, units = 'cm')
  plot(tobs,log10(pvalue$outer),type="l",col="forestgreen",ylab="log10(p)",main=paste0(paste0("p(z>zobs) - IS with kernel and ",B," permutations")))
  lines(tobs,log10(pnorm(tobs,lower.tail = FALSE)),col="red",ylab="")
  #lines(tobs,log10(2.0*(1-pt(tobs, df=length(z)- 2))),col="red",ylab="")
  lines(tobs,log10(pvalue$exp),col="blue",ylab="")
  lines(tobs,log10(pvalue$dc),col="grey2",ylab="")
  
  legend("topright",
         legend=c("outer","True p","exp Kernel", "DC Kernel"),
         fill=c("forestgreen","red","blue","grey2"))
  dev.off()
  
  
  jpeg(paste0("C:/Users/Marion/Documents/Stage/Importance Sampling/Plots/Kernel/Error on IS with kernel and ",B," permutations.jpeg"),res = 450, height = 12, width = 16, units = 'cm')
  plot(tobs,(log10(pvalue$outer)-log10(pnorm(tobs,lower.tail = FALSE)))^2,type="l",ylab="Carre des difference des log10(p)", col="forestgreen",main=paste0("Error on Importance Sampling with kernel and ",B," permutations"))
  lines(tobs,(log10(pvalue$exp)-log10(pnorm(tobs,lower.tail = FALSE)))^2,col="blue",ylab="")
  lines(tobs,(log10(pvalue$dc)-log10(pnorm(tobs,lower.tail = FALSE)))^2,col="grey2",ylab="")
  
  legend("topleft",
         legend=c("outer","exp","DC"),
         fill=c("forestgreen","blue","grey2"))
  dev.off()
  
}
  