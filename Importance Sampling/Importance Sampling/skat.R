Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")
Rcpp::sourceCpp("Importance_Sampling_continu.cpp")

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
DIST<-k2dM(K,direction = "k2d",method="exp",scale = 1) 
nRes<-500

######simuler Y sous Ho et estimer fonction de repartition de QSKAT
####en binaire
tobsB<- seq(800, 1600, by=0.1)
pvalueskatB<-rep(0,length(tobsB))
obj1<-SKAT_Null_Model(SKAT.example$y.b ~ 1, out_type="D",n.Resampling = nRes)

#package -> combili de Chi2
skat1<-SKAT(SKAT.example$Z,obj1,weights=w)$p.value

#Importance sampling

z <- SKAT.example$y.b
zobs <- t((z - mean(z))) %*% K %*% (z -mean(z))
L0 <- c(rep(1L,sqrt(length(DIST))/2),rep(2L,sqrt(length(DIST))/2))

L <- L0; L[1] <- L[1] + 0L # force copie

k <- c( sum(z==0), sum(z==1) )
meanL <- mean(L)
B <- 1e5
w <- numeric(B)
t.perm <- numeric(B)
for(n in 1:B) {
  w[n] <- IS(k, DIST, L, 1)
  t.perm[n] <-(L - meanL) %*% K %*% (L -meanL) 
}

#On modifie les poids pour que la somme fasse 1 :
w <- w / sum(w)

for (j in 1:length(tobsB))
{
  pvalueskatB[j]<-sum( w*(t.perm  > tobsB[j]) )
}

plot(tobsB,log10(pvalueskatB),col="blue",type="l",main = "Binaire")


#####loi normale (0,sigma2*In)
tobsC<- seq(3000,5500,by=0.1)
obj2<-SKAT_Null_Model(SKAT.example$y.c ~ 1, out_type="C",n.Resampling = nRes)
pvalueskatC<-rep(0,length(tobsC))

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

#package -> combili de Chi2
lambda <- eigen(K)$values[1:59]

skat2<-SKAT(SKAT.example$Z,obj2,weights=w)$p.value


#Importance sampling
ng<-sqrt(length(DIST))/5

z <- as.vector(SKAT.example$y.c)
varZ<-var(z)
zsort <- list(z1 = sort(z)[1:ng], z2 = sort(z)[(ng+1):(2*ng)], z3 = sort(z)[(2*ng+1) : (3*ng)], z4 =sort(z)[(3*ng +1) : (4*ng)], z5 = sort(z) [(4*ng+1) : (5*ng)])


zobs <- t(z - mean(z)) %*% K %*% (z -mean(z))/varZ
L0 <- c(rep(1L,sqrt(length(DIST))/5),rep(2L,sqrt(length(DIST))/5),rep(3L,sqrt(length(DIST))/5),rep(4L,sqrt(length(DIST))/5),rep(5L,sqrt(length(DIST))/5))


L <- L0; L[1] <- L[1] + 0L # force copie
k <- c(sqrt(length(DIST))/5, sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5,sqrt(length(DIST))/5)


B <- 1e5
w <- numeric(B)
t.perm <- numeric(B)
meanZ<-mean(z)
for(n in 1:B) {
 w[n] <- IS(k, DIST, L, 1);
 y<-resamp(L,zsort)
 t.perm[n] <-  (y - meanZ) %*% K %*% (y -meanZ)/varZ
}


#On modifie les poids pour que la somme fasse 1 :
w <- w / sum(w)

for (j in 1:length(tobsC))
{
  pvalueskatC[j]<-sum( w*(t.perm  > tobsC[j]) )
}
plot(tobsC,log10(pvalueskatC),col="black",type='l',main = "Continu")


### package Gaston
pgaston<-rep(0,length(tobsC))
for (j in 1:length(tobsC))
{
  pgaston[j]<-gaston:::davies(tobsC[j], lambda, acc = 1e-08) 
}

lines(tobsC,log10(pgaston),col="forestgreen",type="l")


#normal sampling
pnormSamp<-rep(0,length(tobsC))

B <- 1e6
w <- numeric(B)
t.perm <- numeric(B)
meanZ<-mean(z)
for(n in 1:B) {
  w[n] <- 1
  y<-sample(z)
  t.perm[n] <-  (y - meanZ) %*% K %*% (y -meanZ)/varZ
}


#On modifie les poids pour que la somme fasse 1 :
w <- w / sum(w)

for (j in 1:length(tobsC))
{
  pnormSamp[j]<-sum( w*(t.perm  > tobsC[j]) )
}
lines(tobsC,log10(pnormSamp),col="brown",type='l',main = "Continu")
#legend("topright",legend=c("IS", "IS 2", "RGaston","Sampling"), fill = c("black","blue","forestgreen","brown"))
legend("topright",legend=c("IS","RGaston","Sampling"), fill = c("black","forestgreen","brown"))



##importence sampling continu Hervé
pvalueH<-rep(0,length(tobsC))
x<-z[1:(length(z)/2)]
y<-z[(length(z)/2 +1):length(z)]
obs <- cor(x,y)
DIST <- outer(x, x, function(a,b) abs(a-b) )

L <- integer(length(x))
B <- 1e5
w <- numeric(B)
perm <- numeric(B)
theta <- seq(0,2.5,length=B)
y1 <- sort(y)
for(i in 1:B) {
  w[i] <- IS_c(DIST, L, theta[i])
  perm[i] <- cor(x, y1[L])
}

sum( w*(abs(perm) > abs(obs)) )/sum(w) 

for (j in 1:length(tobsC))
{
  pvalueH[j]<-sum( w*(abs(perm)  > tobsC[j]) )/sum(w)
}

# pvalL<-SKAT:::SKAT_Optimal_Linear(res = obj2$res,Z = SKAT.example$Z,
#                                   X1 = obj2$X1,kernel=K,weights = w,
#                                   s2 = obj2$s2, method = "davies", 
#                                   res.out = obj2$res.out,n.Resampling = nRes,  r.all = 0)
# pvalB<-SKAT:::SKAT_Optimal_Logistic(res = obj1$res,Z = SKAT.example$Z,
#                                     X1 = obj1$X1,kernel=K,weights = w,
#                                     pi_1 = obj1$pi_1, method = "davies", 
#                                     res.out = obj1$res.out,n.Resampling = nRes,  r.all = 0)
# 
#                            
# plot(pvalL$p.value.resampling,type='l',col="blue", main =  paste0("Resampling pvalue ", nRes, " times."))                           
# lines(pvalB$p.value.resampling,type='l')                           
# legend("topleft",legend=c("Resampling skat Linear", "Resampling skat Binaire"), fill = c("blue","black"))                           
