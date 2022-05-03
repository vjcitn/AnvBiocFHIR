library(AnvBiocFHIR)
xx = consent_abbrev_map()
which(table(xx[,1])>1) -> ii
library(dplyr)
xx[which(xx[,1][[1]] %in% names(ii)),] |> arrange(Abbrev) |> as.data.frame() |> head(10)
xxs = split(xx, xx[,1][[1]])
nr = sapply(xxs, nrow)
xxsm = xxs[which(nr>1)]
xxok = xxs[which(nr==1)]
cl = lapply(xxsm, function(x) { socc = sum(x$Occurences); ans = x[1,]; ans$Occurences=socc; ans })
zz = do.call(rbind, c(cl, xxok))
write.table(zz, "dedup_disease_consent_codes.tsv", sep="\t", quote=FALSE, row.names=FALSE)
