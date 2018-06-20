Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")

library(SKAT)
data("SKAT.example")

##### Kernel and distance matrix

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

#####"construire le noyau K  =  ZWwZ'

w<-Get_Logistic_Weights(SKAT.example$Z, par1=0.07, par2=150)
W<-diag(w)
K<-SKAT.example$Z%*%W%*%W%*%t(SKAT.example$Z)
DIST<-k2dM(K,direction = "k2d",method="exp",scale = 2) #theta = 1/scale

######simuler Y sous Ho et estimer fonction de repartition de QSKAT
####en binaire
tobs<- seq(0, 10, by=0.01)
pvalueskatB<-rep(0,length(tobs))
obj1<-SKAT_Null_Model(SKAT.example$y.b ~ 1, out_type="D")

#package -> combili de Chi2
skat1<-SKAT(SKAT.example$Z,obj1,weights=w)$p.value

#Importance sampling

z <- SKAT.example$y.b
L0 <- c(rep(1L,sqrt(length(DIST))/2),rep(2L,sqrt(length(DIST))/2))

L <- L0; L[1] <- L[1] + 0L # force copie
k <- c(sqrt(length(DIST))/2, sqrt(length(DIST))/2)

B <- 1000
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
  pvalueskatB[j]<-sum( w*(t.perm  > tobs[j]) )
}

plot(tobs,log10(pvalueskatB),col="blue",type="l")

#####loi normale (0,sigma2*In)
obj2<-SKAT_Null_Model(SKAT.example$y.c ~ 1, out_type="C")
pvalueskatC<-rep(0,length(tobs))
pgaston<-rep(0,length(tobs))

#package -> combili de Chi2
lambda <- eigen(DIST)$values

skat2<-SKAT(SKAT.example$Z,obj2,weights=w)$p.value


#Importance sampling
z <- SKAT.example$y.c
L0 <- c(rep(1L,sqrt(length(DIST))/2),rep(2L,sqrt(length(DIST))/2))

L <- L0; L[1] <- L[1] + 0L # force copie
k <- c(sqrt(length(DIST))/2, sqrt(length(DIST))/2)

B <- 1000
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
  pvalueskatC[j]<-sum( w*(t.perm  > tobs[j]) )
  pgaston[j]<-gaston:::davies(tobs[j], lambda, h = rep(1, length(lambda)),
                     delta = rep(0, length(lambda)), sigma = 0, lim = 10000,
                     acc = 1e-04) 
}

plot(tobs,log10(pvalueskatB),col="blue",type="l")
lines(tobs,log10(pvalueskatC),col="black",type='l')
lines(tobs,log10(pgaston),col="forestgreen",type="l")
legend("topright",legend = c("Y binaire IS", "Y continue IS","Y continue gaston"), fill = c("blue","black","forestgreen"))

plot(tobs,pvalueskatB,col="blue",type="l")
lines(tobs,pvalueskatC,col="black",type='l')
lines(tobs,pgaston,col="forestgreen",type="l")
legend("topright",legend = c("Y binaire IS", "Y continue IS","Y continue gaston"), fill = c("blue","black","forestgreen"))


print(paste0("Pvalue SKAt binaire = ",1-skat1)) #p(z>tobs) ?
print(paste0("Pvalue SKAt continu = ", 1-skat2))

pvalL<-SKAT:::SKAT_Optimal_Linear(res = obj2$res,Z = SKAT.example$Z,
                                  X1 = obj2$X1,kernel=K,weights = w,
                                  s2 = obj2$s2, method = "davies", 
                                  res.out = obj2$res.out,n.Resampling = obj2$n.Resampling,  r.all = 0)$p.value
pvalB<-SKAT:::SKAT_Optimal_Logistic(res = obj1$res,Z = SKAT.example$Z,
                                    X1 = obj1$X1,kernel=K,weights = w,
                                    pi_1 = obj1$pi_1, method = "davies", 
                                    res.out = obj1$res.out,n.Resampling = obj1$n.Resampling,  r.all = 0)$p.value

                           
                           
                           
                           