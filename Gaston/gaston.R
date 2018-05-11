library(gaston)
list.files()
x<-read.bed.matrix('india_400k')
x
str(x)

##presentation des donnees
head(x@snps) #fichier bim
all(x@snps$NAs ==0) #aucune donnee manquante?
str(which(x@snps$NAs > 0)) #donnees manquantes
View(x@snps)
str(which(x@snps$callrate < 1)) #genotypes non obtenus

head(x@ped) #fichier fam
View(x@ped)

##utilisation des donnees
x1<- x[1:100,] #100 premiers ind
x1
x2<-x[,1:10000] #10000 premiers snp pour chaque ind
x2

plot(x@ped$hz,x@ped$callrate)
hist(x@ped$hz) #heterozygotie
hist(x@snps$maf) #freq de l'allele mineure

#selection parmi les snp
x1<-select.snps(x,maf>0.05 &is.autosome(chr)) #autosome = chromosome pas sexuel ou mitochondrie
x1
x2<-select.snps(x,chr == 1)
x2

#selection parmi les individus
garcons<-select.inds(x,sex==1)

#test de qualite des donnees
x<-set.hwe(x, verbose =TRUE) #pvaleurs de l'equilibre de Hardy-Weinberg
hist(x@snps$hwe) #repartition uniforme
qqplot.pvalues(x@snps$hwe) #exces de faibles pvaleurs

x<-set.hwe(x, method="exact") #test exact
hist(x@snps$hwe) #repartition uniforme
qqplot.pvalues(x@snps$hwe) 
head(which(x@snps$hwe>1))

x@snps$hwe[x@snps$hwe >1]<-1
qqplot.pvalues(x@snps$hwe) #gros ecart avec la ligne rouge

set.genomic.sex(x)
x<-set.genomic.sex(x,plot=TRUE)

##fichier population
T<-read.table("india_400k.population",header=TRUE)
head(T)
table(T$population)
all(T$famid==x@ped$famid)

#PCA
x1<-select.snps(x,is.autosome(chr) & maf > 0.05)
x2<-LD.thin(x1,0.1) #seuil de correleation entre es snps
K<-GRM(x2) #matrice de correlation entre les ind
reshape.GRM(K,include = c(0.2,Inf)) #correlations au dessus de 0.2
eiK<-eigen(K)
plot(eiK$vectors,col=T$population) #difference entre populations sur les deux premieres compa
legend("bottomright",pch=1,col=1:5,legend = levels(T$population))
plot(eiK$vectors[,3],eiK$vectors[,4],col=T$population) #compo 3 et 4 
legend("bottomright",pch=1,col=1:5,legend = levels(T$population))

