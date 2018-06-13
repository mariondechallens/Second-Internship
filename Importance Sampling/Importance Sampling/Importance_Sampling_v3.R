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

# vect<-runif(100,0.4,0.65)
# result<-data.frame(matrix(nrow=3*length(vect),ncol=3))
# colnames(result)<-c("Dist.matrix","True.p.student","IS.t.test")
# result$Dist.matrix<-rep(c("outer","exp Kernel","DC kernel"),length(vect))
# 
# l<-1 # pour remplir result
# v<-1 # pour indicier vect

tobs<- seq(0, 5, by=0.01)
pvalue<-list(outer=rep(0,length((tobs))),exp=rep(0,length(tobs)),dc=rep(0,length(tobs)))

# while (l < nrow(result))

  # print(paste0("l = ",l))
  # print(paste0("v = ",v))
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
  
  B <- 10000
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
  #  F <- function(z, L) abs(t.test(z ~ L, var.equal = TRUE)$statistic)
  # F <- function(z, L) abs(t_test(z, L))
  # 
  # t.obs <- F(z, L0);
  
  ## Distance matrix with outer 
  # result[l,2]<- 2.0*(1-pt(t.obs, df=length(z)- 2)) # True p-value
  # result[l,3]<-Run_IS_t_test(z, L0, DIST, 1e5, 0.8, 2)$p
  
  ## Distance matrix with exponential Kernel 
  theta<-0.6
  Ke<-k2dM(DIST,direction="d2k",method="exp",scale=1/theta)
  DISTe<-log(Ke)*(-1/theta)
  
  w <- numeric(B)
  for(n in 1:B) {
    w[n] <- IS(k, DISTe, L, 0.6); 
    t.perm[n] <- t_test(z , L)
  }
  
  #On modifie les poids pour que la somme fasse 1 :
  w <- w / sum(w)
  
  for (j in 1:length(tobs))
  {
    pvalue$exp[j]<-sum( w*(t.perm  > tobs[j]) )
  }
  # result[l+1,2]<- 2.0*(1-pt(t.obs, df=length(z)- 2)) # True p-value
  # result[l+1,3]<-Run_IS_t_test(z, L0, DISTe, 1e5, 0.8, 2)$p
  
  ## Distance matrix with DC Kernel 
  Kdc<-k2dM(DIST,direction="d2k",method="DC")
  DISTdc<-DIST-DIST
  for (i in 1:nrow(DISTdc))
  {
    for (j in 1:ncol(DISTdc))
    {
      if (z[i]^2 + z[j]^2 - 2*Kdc[i,j] < 0)
        DISTdc[i,j] <- 0
      else
        DISTdc[i,j] <- sqrt(z[i]^2 + z[j]^2 - 2*Kdc[i,j])
    }
  }
  
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
  # result[l+2,2]<- 2.0*(1-pt(t.obs, df=length(z)- 2)) # True p-value
  # result[l+2,3]<-Run_IS_t_test(z, L0, DISTe, 1e5, 0.8, 2)$p


# View(result)
# write.csv2(result,"result.csv")
# 
# plot(vect,-log10(subset(result,result$Dist.matrix == "DC kernel")$True.p.student),col="red",type="l")
# lines(vect,-log10(subset(result,result$Dist.matrix == "DC kernel")$IS.t.test),col="blue")
# lines(vect,-log10(subset(result,result$Dist.matrix == "exp Kernel")$IS.t.test),col="forestgreen")
# lines(vect,-log10(subset(result,result$Dist.matrix == "outer")$IS.t.test),col="yellow")
# legend("topleft",
#        legend=c("True.p.student","DC Kernel","expo Kernel", "outer"),
#        fill=c("red","blue","forestgreen","yellow"))
  
  plot(tobs,log10(pvalue$outer),type="l",col="forestgreen",ylab="log10(p)",main=paste0("p(z>zobs) - Importance Sampling with kernel"))
  lines(tobs,log10(pnorm(tobs,lower.tail = FALSE)),col="red",ylab="")
  lines(tobs,log10(pvalue$exp),col="blue",ylab="")
  lines(tobs,log10(pvalue$dc),col="grey2",ylab="")
  
  legend("topright",
         legend=c("outer","True p normale","exp Kernel", "DC Kernel"),
         fill=c("forestgreen","red","blue","grey2"))
