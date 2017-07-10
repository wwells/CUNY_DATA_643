getSizeDim <- function(obj){
    # given an object print out size and dimensions
    st <-deparse(substitute(obj))
    print(paste0("Object ", st, " size: ", round(object.size(obj)/1024/1024, 3), " MB |  Dim: ", 
             dim(obj)[1], ' ', dim(obj)[2]))
}

