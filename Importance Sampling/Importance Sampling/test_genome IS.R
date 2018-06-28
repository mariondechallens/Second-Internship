Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")

load("C:/Users/Marion/Documents/Stage/packageBC/Data/FST5_50.RData") 
#the observed test stat is the 501th value of gene
#the 500 first are the test statistics got by permutations 
FST<-FST.1

result<-data.frame(matrix(nrow=length(FST),ncol=2))
colnames(result)<-c("Gene","pvalueIS")
result$Gene<-names(FST)


####### Functions
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
#########

for (i in 1:length(FST))
{
  print(i)
  z <- FST[[i]][1:500]
  zo <- FST[[i]][501]
  # la matrice de distances entre tous les elts de z
  DIST <- outer(z, z, function(a,b) abs(a-b) )
  K<-k2dM(DIST,direction="d2k",method = "exp",scale = 1)
  
  #Importance sampling
  ng<-sqrt(length(DIST))/5
  varZ<-var(z)
  zsort <- list(z1 = sort(z)[1:ng], z2 = sort(z)[(ng+1):(2*ng)], z3 = sort(z)[(2*ng+1) : (3*ng)], z4 =sort(z)[(3*ng +1) : (4*ng)], z5 = sort(z) [(4*ng+1) : (5*ng)])
  
  zobs <- t((z - mean(z))) %*% K %*% (z -mean(z))
  L0 <- c(rep(1L,sqrt(length(DIST))/5),rep(2L,sqrt(length(DIST))/5),rep(3L,sqrt(length(DIST))/5),rep(4L,sqrt(length(DIST))/5),rep(5L,sqrt(length(DIST))/5))
  
  L <- L0; L[1] <- L[1] + 0L # force copie
  k <- c(sqrt(length(DIST))/5, sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5)
  
  B <- 1e5
  w <- numeric(B)
  t.perm <- numeric(B)
  meanZ<-mean(z)
  for(n in 1:B) {
    w[n] <- IS(k, DIST, L, 1);
    #y<-resamp(L,zsort)
    c<-rep(0,10) # regrouper les differentes statistiques calculees
    cpt<-1  # compteur
    for (j in 1:(length(zsort) - 1))
    {
      for (m in (j+1):length(zsort))
      {
        Lbis<-L[L==j | L==m]
        Lbis[Lbis==j]<-1
        Lbis[Lbis==m]<-2
        c[cpt]<- t_test(c(zsort[[j]],zsort[[m]]),Lbis)
        cpt = cpt + 1
      }
    }
    t.perm[n] <-  max(c) #(y - meanZ) %*% K %*% (y -meanZ)/varZ
  }
  
  
  #On modifie les poids pour que la somme fasse 1 :
  w <- w / sum(w)

  result$pvalueIS[i]<-sum( w*(abs(t.perm)  > zobs[1,1]) )
  
}

write.csv2(result, file="C:/Users/Marion/Documents/Stage/Importance Sampling/Importance_sampling/pvalueIS.csv",row.names=F)

result[is.na(result)]<-0
resultB<-read.csv2("C:/Users/Marion/Documents/Stage/packageBC/pvalue.csv")
resultF<-rbind(resultB,result)

write.csv2(resultF, file="C:/Users/Marion/Documents/Stage/packageBC/pvalue.csv",row.names=F)

# Manhattan plot: plus la p valeur est faible, plus l'assocation entre le SNP et la maladie est grande
# Pvaleur :  proba d'accepter H0 : "pas d association".
# library(qqman)
# manhattan(yy[,-1],col = c("blue4", "orange3"),ylim=c(4,32),suggestiveline=FALSE, las=2)

