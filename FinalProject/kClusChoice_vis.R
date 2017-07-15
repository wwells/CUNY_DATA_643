library("factoextra")
library("cluster")

binSVD <- readRDS("facBinMatrices.rds")
facUsers <- binSVD$u 

#facUsers <- facUsers[1:1000, ] #subset to test

ptm <- proc.time()

p_wss <- fviz_nbclust(scale(facUsers), clara, method = "wss", k.max = 30)
print("Wss Sim Complete")
p_sil <- fviz_nbclust(scale(facUsers), clara, method = "silhouette", k.max = 30)
print("Sil Sim Complete")
print("Compiling Results...")

finaltime <- proc.time() - ptm
print(finaltime)

plots <- list(wss = p_wss, 
              sil = p_sil, 
              simtime = finaltime)
saveRDS(plots, "kClusPlots.rds")