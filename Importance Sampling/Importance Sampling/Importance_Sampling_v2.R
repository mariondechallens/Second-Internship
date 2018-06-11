Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
Rcpp::sourceCpp("Importance_Sampling_v1.cpp")


#### proba empirique avec importance sampling

mean<-c(0,0.4,0.45,0.5,0.55)
Nperm<-c(1e4,1e5,1e6)
for (nb in Nperm)
{
  print (paste0("Nperm = ",nb))
  for (m in mean)
  {
    pvalue<-list(zero=rep(0,500),zero5=rep(0,500),un=rep(0,500))
    tobs<- seq(0, 10, by=0.01)
    theta<-c(0,0.5,1)
    
    for (i in 1:length(theta))
    {
      set.seed(1)
      x <- rnorm(200, mean=0, sd=1)
      y <- rnorm(200, mean=m, sd=1)
      z <- c(x,y)
      L0 <- c(rep(1L,200),rep(2L,200))
      
      # la matrice de distances entre tous les elts de z
      DIST <- outer(z, z, function(a,b) abs(a-b) )
      L <- L0; L[1] <- L[1] + 0L # force copie
      k <- c(length(x), length(y))
      
      B <- nb;
      w <- numeric(B)
      t.perm <- numeric(B)
      for(n in 1:B) {
        w[n] <- IS(k, DIST, L, theta[i]); 
        t.perm[n] <- t_test(z , L)
      }
      
      #On modifie les poids pour que la somme fasse 1 :
      w <- w / sum(w)
      
      for (j in 1:length(tobs))
      {
        pvalue[[i]][j]<-sum( w*(t.perm  > tobs[j]) )
      }
      
    }
    
    jpeg(paste0("C:/Users/Marion/Documents/Stage/Importance Sampling/Plots/mean_",m,"_",nb,".jpeg"),res = 450, height = 12, width = 16, units = 'cm')
    plot(tobs,log10(pvalue$un),type="l", ylim=c(-20,0),col="forestgreen",ylab="log10(p)",main=paste0("p(z>zobs) - Importance Sampling - mean ",m," - Nperm = ",nb))
    lines(tobs,log10(pnorm(tobs,lower.tail = FALSE)),col="red",ylab="")
    lines(tobs,log10(pvalue$zero5),col="blue",ylab="")
    lines(tobs,log10(pvalue$zero),col="grey2",lwd=2,ylab="")
    
    legend("topright",
           legend=c("theta = 1","theta = 0.5","theta = 0", "Vraie distribution"),
           fill=c("forestgreen","blue","grey2","red"))
    dev.off()
    
    jpeg(paste0("C:/Users/Marion/Documents/Stage/Importance Sampling/Plots/sd_mean_",m,"_",nb,".jpeg"),res = 450, height = 12, width = 16, units = 'cm')
    plot(tobs,(log10(pvalue$un)-log10(pnorm(tobs,lower.tail = FALSE)))^2,type="l",xlim=c(3,10),ylab="Carre des difference des log10(p)", col="forestgreen",main=paste0("Erreur - Importance Sampling - mean ",m," - Nperm = ",nb))
    lines(tobs,(log10(pvalue$zero5)-log10(pnorm(tobs,lower.tail = FALSE)))^2,col="blue",ylab="")
    lines(tobs,(log10(pvalue$zero)-log10(pnorm(tobs,lower.tail = FALSE)))^2,col="grey2",lwd=2,ylab="")
    
    legend("topleft",
           legend=c("theta = 1","theta = 0.5","theta = 0"),
           fill=c("forestgreen","blue","grey2"))
    dev.off()
    
    sink(paste0("C:/Users/Marion/Documents/Stage/Importance Sampling/sd_mean_",m,"_",nb,".txt"))
    print("theta = 0")
    print(sum(tail((log10(pvalue$zero)-log10(pnorm(tobs,lower.tail = FALSE)))^2),300))
    print("theta = 0.5")
    print(sum(tail((log10(pvalue$zero5)-log10(pnorm(tobs,lower.tail = FALSE)))^2),300))
    print("theta = 1")
    print(sum(tail((log10(pvalue$un)-log10(pnorm(tobs,lower.tail = FALSE)))^2),300))
    sink()
    
  }
}


