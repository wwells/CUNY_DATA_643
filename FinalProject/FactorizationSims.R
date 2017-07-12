suppressMessages(library(Matrix))
suppressMessages(library(recommenderlab))
suppressMessages(library(ggplot2))
suppressMessages(library(rARPACK))
suppressMessages(library(reshape2))
source('helper.R')

BinBook <- readRDS("binBookM.rds")
Book <- readRDS("BookM.rds")

SparseM <- as(Book, "dgCMatrix")
SparseMBin <- as(BinBook, "dgCMatrix")

klist <- seq(5, 80, by=1)
N_sims <- 10
N_subset <- 10000

ptm <- proc.time()
print("Starting Sims...")

EX_70SVD <- sapply(klist,
                    GetSVDsRMSE,
                    N_subset = N_subset, 
                    N_sims = N_sims,
                    SparseMatrix = SparseM, 
                    keepVar = .70)
print("Job 1 of 6 Complete")

EX_80SVD <- sapply(klist,
                    GetSVDsRMSE,
                    N_subset = N_subset, 
                    N_sims = N_sims,
                    SparseMatrix = SparseM, 
                    keepVar = .80)

print("Job 2 of 6 Complete")

EX_90SVD <- sapply(klist,
                    GetSVDsRMSE,
                    N_subset = N_subset, 
                    N_sims = N_sims,
                    SparseMatrix = SparseM, 
                    keepVar = .90)
print("Job 3 of 6 Complete")

IM_70SVD <- sapply(klist,
                    GetSVDsRMSE,
                    N_subset = N_subset, 
                    N_sims = N_sims,
                    SparseMatrix = SparseMBin, 
                    keepVar = .70)

print("Job 4 of 6 Complete")

IM_80SVD <- sapply(klist,
                    GetSVDsRMSE,
                    N_subset = N_subset, 
                    N_sims = N_sims,
                    SparseMatrix = SparseMBin, 
                    keepVar = .80)
print("Job 5 of 6 Complete")
IM_90SVD <- sapply(klist,
                    GetSVDsRMSE,
                    N_subset = N_subset, 
                    N_sims = N_sims,
                    SparseMatrix = SparseMBin, 
                    keepVar = .90)
print("Job 6 of 6 Complete")
simresults <- data.frame(k = klist,
                        Ex_Var70 = simMeans(EX_70SVD, N_sims, klist),
                        Ex_Var80 = simMeans(EX_80SVD, N_sims, klist), 
                        Ex_Var90 = simMeans(EX_90SVD, N_sims, klist),
                        Im_Var70 = simMeans(IM_70SVD, N_sims, klist),
                        Im_Var80 = simMeans(IM_80SVD, N_sims, klist), 
                        Im_Var90 = simMeans(IM_90SVD, N_sims, klist))
print("Compiling Results...")
finaltime <- proc.time() - ptm
print(finaltime)

saveRDS(finaltime, 'simtime.rds')
saveRDS(simresults, 'simresults.rds')