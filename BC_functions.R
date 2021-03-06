####Fonctions utiles pour estimer la p-valeur

#calcul du nombre de stats simulees superieures a Zobs
nb_exc<-function(x0,z){  ##pas besoin d'une boucle en fait
  M<-length(z[z>=x0])
  return(M)
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

# estimateur du max de vraisemblance (via une vraisemblance profilee)
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
FGPD<-function(z,zexc,estim){
  if (estim == "EMV")
    coeff<-EMV(zexc)
  else
    coeff<-PWM(zexc)
  a<-coeff$a
  k<-coeff$k
  if (k!= 0)
    return(list(val = 1-(1-k*z/a)^(1/k),
                k = k,
                a = a))
  else
    return(list(val = 1-exp(-z/a),
                k = k,
                a = a))
}

#calcul de Pgpd
PGPD<-function(x0,zexc,y,seuil,estim){
  M<-nb_exc(x0,y)
  result<-FGPD(x0-seuil,zexc,estim)
  if(M >= 10)
    return(list(p = M/length(y),
                k = result$k,
                a = result$a ))
  else {
    return(list( p = length(zexc)/length(y)*(1-result$val),
                 k = result$k,
                 a = result$a ))
  }
}
##Box-Cox transformation ----

BoxCox<-function(z,lambda){
  if (lambda != 0)
    return((z^lambda - 1)/lambda)
  else
    return(log(z))
}

#BC applique a la statistique z

BoxCox_lm <- function(Y,X) {  #estimation de lambda par les moindres carres
  f <- function(lambda) {
    if(lambda == 0)
      X <- log(X)
    else
      X <- (X**lambda - 1)/lambda

    b <-  cov(X,Y) / var(X)
    a <- mean(Y) - b*mean(X)
    sum( (Y - a - b*X)**2 )
  }
  optimize(f,c(0,1))$minimum
}

PBC_Z<-function(z,Ntot,N,param,Zobs){
  p<-seq(N,1)/Ntot
  if (missing(param))
    lambda <- BoxCox_lm(log(-log(p)),log(z))
  else
    lambda <- param
  coeffs <- lm(  log(-log(p)) ~ BoxCox(log(z),lambda) )$coefficients
  return(list(p = exp(-exp(sum( coeffs*c(1, BoxCox(log(Zobs),lambda))))),
              interc = coeffs[[1]],
              pente = coeffs[[2]],
              lbda = lambda))

}

## regroupement des p valeurs des differentes methodes ----

calcul_p<-function(zsim,Ntail=500,estim=c("PWM","EMV"),Zobs,param,method = c("BC","GPD")){
  # les Ntail plus grandes valeurs (les dernieres)
  z1 <- tail( sort(zsim) , Ntail + 1 )
  #seuil pour la GDP
  t<-(z1[1] + z1[2])/2
  #calcul des excedents de la GDP, ceux qui lui sont superieurs
  z1<-z1[-1]
  zgpd<-z1-t
  zgpd<-zgpd[zgpd>0] #uniquement ceux superieurs au seuil

  method<-match.arg(method)
  if (method == "BC") {
    result<-PBC_Z(z1,length(zsim),Ntail,param,Zobs)
    return(list(Pbc_z = result$p,
                lbda = result$lbda))
  }

  if (method =="GPD"){
    estim<-match.arg(estim)
    result<-PGPD(Zobs,zgpd,zsim,t,estim)
    return(list(Pgpd=result$p,
                  a=result$a,
                  k=result$k))

  }


}


