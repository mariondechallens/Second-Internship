# require(oz)
# x <- read.bed.matrix("1KG_eur_maf1pm_genes_chr22")
# FST <- Sum.Fst(x, group = x@ped$population, genomic.region = x@snps$gene)
# write.table(FST, file = "FST_chr22.txt")
#
# start<-Sys.time()
# FST.1 <- Sum.Fst.higher.perms(x,  group = x@ped$population, genomic.region = x@snps$gene, which.snps = x@snps$gene %in% c("SHANK3", "IL17RA", "CECR5"), n.keep = 500, B = 1e6)
# end <- Sys.time()
# print(end - start)
# save(FST.1, file = "FST_1.RData")


library(PvalueEsti)
load("C:/Users/Marion/Documents/Stage/packageBC/FST5_2951_4344.RData")  #10^5 permutations!!
FST<-FST.7

result<-data.frame(matrix(nrow=length(FST),ncol=4))
colnames(result)<-c("Genes","GPD.PWM","GPD.EMV","BC.LS")
result$Genes<-names(FST)
lam<-rep(0,length(FST))

for (i in 1:length(FST)){
  gene<-FST[[i]]
  #the observed test stat is the 501th value of gene
  #the 500 first are the test statistics got by permutations
  result[i,2]<-calcul_p(zsim=gene[1:500],
                Zobs=gene[501],
                method="GPD",
                estim="PWM",
                Nperm = 1e5,
                draw=F)$Pgpd
  result[i,3]<-calcul_p(zsim=gene[1:500],
                Zobs=gene[501],
                method="GPD",
                estim="EMV",
                Nperm=1e5,
                draw=F)$Pgpd

  res<-calcul_p(zsim=gene[1:500],
              Zobs=gene[501],
              method="BC",
              Nperm = 1e5,
              draw=F)
  result[i,4]<-res$Pbc_z
  lam[i] <- res$lbda


}

result[is.na(result)]<-0
resultB<-read.csv2("C:/Users/Marion/Documents/Stage/packageBC/pvalue.csv")
resultF<-rbind(resultB,result)

write.csv2(resultF, file="C:/Users/Marion/Documents/Stage/packageBC/pvalue.csv",row.names=F)


boxplot(-log10(resultF$BC.LS),-log10(resultF$GPD.PWM),-log10(resultF$GPD.EMV),ylim=c(1,15),names=c("Box-Cox","GPD_PWM","GPD_EMV"))

# Manhattan plot: plus la p valeur est faible, plus l'assocation entre le SNP et la maladie est grande
# Pvaleur :  proba d'accepter H0 : "pas d association".
# library(qqman)
# manhattan(yy[,-1],col = c("blue4", "orange3"),ylim=c(4,32),suggestiveline=FALSE, las=2)

