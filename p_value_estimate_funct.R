####Fonctions utiles pour estimer la p-valeur 

### Librairie a charger ----
library(MASS)

### Fonctions ----

#calcul du nombre de stats simulees superieures a Zobs
nb_exc<-function(x0,z){  ##pas besoin d'une boucle en fait
  M<-length(z[z>=x0])
  return(M)
}

#calcul de Pecdf----
PECDF<-function(x0,y){
  return((1+nb_exc(x0,y))/length(y))
}

#critere de queue lourde a appliquer a Zsim[[nbsim]]
critereLourd<-function(z,N){
  z<-sort(z)
  p<-seq(1,N)/N #proba empiriques p(X<Z)
  d<-diff(c(z[sum(p<=0.97)],z[sum(p<=0.98)], z[sum(p<=0.99)],z[sum(p<=0.999)])) #diff des ecarts des quantiles empiriques
  R<-(d[3]-d[2])/(d[2]-d[1])
  if (R > 6)
    return(TRUE) ##queue lourde, on prend le log des statistiques de test
  else
    return(FALSE)
}
#GPD ----
# estimateur PWM pour les parametres de la GPD
PWM <- function(z) {
  n <- length(z)
  p <- (seq.int(n)-0.35)/n
  t <- mean( (1-p)*z )
  mu <- mean(z)
  k <- mu/(mu-2*t)-2
  a <- 2*mu*t/(mu-2*t)
  list(a = a, k = k)
}

# estimateur du max de vraisemblance (via une vraisemblance profilée)
k_func <- function(u, z) -mean(log(1-u*z))

Lp <- function(u,z) {
  n <- length(z)
  if(u == 0) 
    return( -n*(log(mean(z)) + 1) )
  k <- k_func(u,z)
  n*(log(u/k) + k - 1)
}

EMV <- function(z) {
  u <- optimize(function(u) Lp(u,z), c(-10, min(1/z)), maximum=TRUE )$maximum
  if(u == 0) 
    return(list( a = mean(z), k = 0))
  k <- k_func(u, z)
  list(a = k/u, k = k)
}


#Fonction de repartition de Pareto
FGPD<-function(z,zexc){
  coeff<-EMV(zexc)
  a<-coeff$a
  k<-coeff$k
  if (k!= 0)
    return(1-(1-k*z/a)^(1/k))
  else
    return(1-exp(-z/a))
}

#calcul de Pgpd
PGPD<-function(x0,zexc,y,seuil){
  M<-nb_exc(x0,y)
  if(M >= 10)
    return(M/length(y))
  else
    return(length(zexc)/length(y)*(1-FGPD(x0-seuil,zexc)))
}

#le modele lineaire ----
PML<-function(z,Ntot,N){
  p <- seq(N,1)/Ntot
  # le modele ~ lineaire 
  # estimation de P( Z > Zobs) par regression lineaire
  if (critereLourd(Zsim[[nbsim]],end) == TRUE){
    coeffs <- lm(  log(-log(p)) ~ log(log(z)) )$coefficients
    return(list(p = exp(-exp( sum( coeffs*c(1, log(log(Zobs))) ) )), 
                inter = coeffs[[1]], 
                pente = coeffs[[2]]))}
  if (critereLourd(Zsim[[nbsim]],end) == FALSE){
    coeffs <- lm(  log(-log(p)) ~ log(z) )$coefficients
    return(list(p = exp(-exp( sum( coeffs*c(1, log(Zobs)))  )), 
              inter = coeffs[[1]], 
              pente = coeffs[[2]]))}
}

##Box-Cox transformation ----

BoxCox<-function(z,lambda){
  if (lambda != 0)
    return((z^lambda - 1)/lambda)
  else
    return(log(z))
}

#BC applique a la proba p
PBC<-function(z,Ntot,N){  
  p<-seq(N,1)/Ntot
  if (critereLourd(Zsim[[nbsim]],end) == FALSE){
    b<-boxcox( log(-log(p)) ~ log(z),plotit=F) ##which lambda to choose
    lambda <- b$x[which.max(b$y)]
    coeffs <- lm(  BoxCox(log(-log(p)),lambda) ~ log(z) )$coefficients
    Bp<-sum( coeffs*c(1, log(Zobs)))
    if (lambda != 0)
      return(list(p = exp(-exp((Bp*lambda+1)^(1/lambda))), 
                  interc = coeffs[[1]], 
                  pente = coeffs[[2]],
                  lbda = lambda))
    else
      return(list(p = exp(-exp(exp(Bp))),
                  interc = coeffs[[1]], 
                  pente = coeffs[[2]],
                  lbda = lambda))
  }
  if (critereLourd(Zsim[[nbsim]],end) == TRUE){
    b<-boxcox( log(-log(p)) ~ log(log(z)),plotit=F) ##which lambda to choose
    lambda <- b$x[which.max(b$y)]
    coeffs <- lm(  BoxCox(log(-log(p)),lambda) ~ log(log(z)) )$coefficients
    Bp<-sum( coeffs*c(1, log(log(Zobs))))
    if (lambda != 0)
      return(list(p = exp(-exp((Bp*lambda+1)^(1/lambda))), 
                  interc = coeffs[[1]], 
                  pente = coeffs[[2]],
                  lbda = lambda))
    else
      return(list(p = exp(-exp(exp(Bp))),
                  interc = coeffs[[1]], 
                  pente = coeffs[[2]],
                  lbda = lambda))
  }
}

#BC applique a la statistique z

box.cox.lm <- function(Y,X) {  #estimation de lambda par les moindres carrés
  f <- function(lambda) {
    if(lambda == 0)
      X <- log(X)
    else
      X <- (X**lambda - 1)/lambda
    
    b <-  cov(X,Y) / var(X)
    a <- mean(Y) - b*mean(X)
    #cat("lambda = ", lambda, " a = ", a, "b = ", b, "\n")
    sum( (Y - a - b*X)**2 )
  }
  optimize(f,c(0,1))$minimum
}

PBC_Z<-function(z,Ntot,N){  
  p<-seq(N,1)/Ntot
  lambda <- box.cox.lm(log(-log(p)),log(z))
  coeffs <- lm(  log(-log(p)) ~ BoxCox(log(z),lambda) )$coefficients
  return(list(p = exp(-exp(sum( coeffs*c(1, BoxCox(log(Zobs),lambda))))), 
                interc = coeffs[[1]], 
                pente = coeffs[[2]],
                lbda = lambda))
  
}

## regroupement des p valeurs des differentes methodes ----

calcul_p<-function(zsim,Ntail){  
  # les Ntail plus grandes valeurs (les dernieres)
  z1 <- tail( sort(zsim) , Ntail )
  #seuil pour la GDP
  t<-(z1[1] + head(sort(zsim,decreasing =TRUE),Ntail+1)[Ntail+1])/2
  #calcul des excedents de la GDP, ceux qui lui sont sup?rieurs
  zgpd<-z1-t
  zgpd<-zgpd[zgpd>0] #uniquement ceux sup?rieurs au seuil
  
  return(list(Pecdf = PECDF(Zobs,zsim),
              Pgpd=PGPD(Zobs,zgpd,zsim,t),
              Plin=PML(z1,length(zsim),Ntail)$p,
              Pbc = PBC(z1,length(zsim),Ntail)$p,
              Pbc_z = PBC_Z(z1,length(zsim),Ntail)$p,
              lbda = PBC_Z(z1,length(zsim),Ntail)$lbda,
              a=PWM(zgpd)$a,
              k=PWM(zgpd)$k))
}


