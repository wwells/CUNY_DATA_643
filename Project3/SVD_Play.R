library(ggplot2)

set.seed(643)
n <- 100
m <- round(n/2, 0)
#percentNAs <- .3
#probs <- c(1-percentNAs, percentNAs)

# generate data
toyDF <- as.data.frame(replicate(m, floor(runif(n, 1,6))))

# test with lower rank matrix
#toyDF <- as.data.frame(matrix(
#    c(1,1,1,0,
#      2,2,2,0,
#      3,3,3,0,
#      0,0,0,4,
#      0,0,0,3), byrow=T, 5, 4
#))

## intro NAs
#toyDF <- as.data.frame(
#    lapply(toyDF, function(df) df[sample(c(TRUE, NA), prob = probs, size = length(df), replace = TRUE) ]), 
#    row.names = users, 
#    col.names = items)

x <- svd(toyDF)
S <- diag(x$d)
U <- x$u
V <- x$v

M <- U %*% S %*% t(V)

## How many to dimensions to keep?
# want to keep about ~90% of the variance.  
SVDRemoveTable <- function(s) {
    df <- data.frame()
    for (i in seq(nrow(s))) {
        m <- sum(s[1:i, 1:i]^2)/sum(s^2)
        df <- rbind(df, c(i, m))
    }
    names(df) <- c("concepts", "variability")
    df
}

mytable <- SVDRemoveTable(S)

mu <- 4

## Remove elements  
NewS <- S[1:mu, 1:mu]
NewU <- U[,1:mu]
NewV <- V[,1:mu]



## Create new M, should we want to
if (is.null(nrow(NewS))) {
    NewM <- NewU * NewS %*% t(NewV)
} else {
    NewM <- NewU %*% NewS %*% t(NewV)
}

## Test replace diag w/ 0s
AltS <- svd(toyDF)$d
AltS[(mu+1):length(AltS)] <- 0
AltS <- diag(AltS)
NewMA <- U %*% AltS %*% t(V)

NewMA == NewM

ggplot(mytable, aes(concepts, variability)) + geom_point() + 
    geom_hline(yintercept = .9, color='orange', linetype='dashed') + 
    ggtitle(expression(SVD:~Mapping~Sigma~Concepts~to~Variability))

