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
load("C:/Users/Marion/Documents/Stage/packageBC/FST5_151_450.RData")

result<-data.frame(matrix(nrow=length(FST.3),ncol=4))
colnames(result)<-c("Genes","GPD.PWM","GPD.EMV","BC.LS")
result$Genes<-names(FST.3)

for (i in 1:length(FST.3)){
  gene<-FST.3[[i]]
  #the observed test stat is the 501th value of gene
  #the 500 first are the test statistics got by permutations
  result[i,2]<-calcul_p(zsim=gene[1:500],
                Zobs=gene[501],
                method="GPD",
                estim="PWM",
                Nperm = 1e6,
                draw=T)$Pgpd
  result[i,3]<-calcul_p(zsim=gene[1:500],
                Zobs=gene[501],
                method="GPD",
                estim="EMV",
                Nperm=1e6,
                draw=T)$Pgpd

  result[i,4]<-calcul_p(zsim=gene[1:500],
              Zobs=gene[501],
              method="BC",
              Nperm = 1e6,
              draw=F)$Pbc_z

}

resultB<-read.csv2("C:/Users/Marion/Documents/Stage/packageBC/pvalue.csv")
resultF<-rbind(resultB,result)
write.csv2(resultF, file="C:/Users/Marion/Documents/Stage/packageBC/pvalue.csv",row.names=F)

