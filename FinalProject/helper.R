getSizeDim <- function(obj){
    # given an object print out size and dimensions
    st <-deparse(substitute(obj))
    print(paste0("Object ", st, " size: ", round(object.size(obj)/1024/1024, 3), " MB |  Dim: ", 
             dim(obj)[1], ' ', dim(obj)[2]))
}

GetSVDsRMSE <- function(N_subset, N_sims, SparseMatrix, k, keepVar) {
    # Computes a list of RMSE values of the Truncated SVD to help tuning.  
    # Uses sampling because difficult to manage calc of full RMSE
    #
    # Args:
    #   N_subset:  size of final sampled | predicted matrix (sample will be square for ease)
    #   N_sims:  number of times to sample and calc RMSE based on calculated SVD
    #   SparseMatrix: Matrix to factorize
    #   k:  number of features to use in svds calculation
    #   keepVar: percent of the singular values to retain
    #
    # Returns:
    #   A list of RMSE for each sample taken
    
    mylist <- list()
    
    # calculate truncated svd
    x <- svds(SparseMatrix, k)
    SMat <- diag(x$d)
    U <- x$u
    V <- x$v

    # reduction
    n <- keepVar * k
    NewSMat <- SMat[1:n, 1:n]
    NewU <- U[,1:n]
    NewV <- V[,1:n]
    
    # print output for logging
    print(paste0(deparse(substitute(SparseMatrix)), " | keepVar: ", deparse(substitute(keepVar)), " | k: ", k))

    for (i in 1:N_sims) {
        # sample to calc RMSE
        startV <- sample(1:nrow(SparseMatrix), N_subset)
        startU <- sample(1:ncol(SparseMatrix), N_subset)
        
        # create new mat
        SubU <- NewU[startV,]
        SubV <- NewV[startU,]
        PredSamp <- SubU %*% NewSMat %*% t(SubV)
        KnownSamp <- as(Book[startV, startU], 'matrix')

        # only calc RMSE for actual observed
        PredSamp[is.na(KnownSamp)] <- NA

        rmse <- RMSE(KnownSamp, PredSamp)
        mylist[[i]] <- rmse
    }
    mylist
}

simMeans <- function(simresults, N_sims, klist) {
    # takes results from GetSVDsRMSE, returns a named list of means for each k simulated
    testfull <- matrix(as.numeric(simresults), N_sims, length(klist))
    meansByK <- colMeans(testfull)
    names(meansByK) <- klist
    meansByK
}