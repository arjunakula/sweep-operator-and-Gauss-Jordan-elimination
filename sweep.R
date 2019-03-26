############################################################# 
## Stat 202A - Homework 1
## Author: 
## Date : 
## Description: This script implements the sweep operator as
## well as Gauss-Jordan elimination in both plain and
## vectorized form
#############################################################

#############################################################
## INSTRUCTIONS: Please fill in the missing lines of code
## only where specified. Do not change function names, 
## function inputs or outputs. You can add examples at the
## end of the script (in the "Optional examples" section) to 
## double-check your work, but MAKE SURE TO COMMENT OUT ALL 
## OF YOUR EXAMPLES BEFORE SUBMITTING.
##
## Very important: Do not use the function "setwd" anywhere
## in your code. If you do, I will be unable to grade your 
## work since R will attempt to change my working directory
## to one that does not exist.
#############################################################


## ~~~~~~~~~~~~~~~~~~~~~ ##
## ~~~~~ Problem 1 ~~~~~ ##
## ~~~~~~~~~~~~~~~~~~~~~ ##  


#################################
## Function 1: Sweep operation ##
#################################

mySweep <- function(A, m){
  
  # Perform a SWEEP operation on the square matrix A with the 
  # pivot element A[m,m].
  # 
  # A: a square matrix.
  # m: the pivot element is A[m, m].
  # Returns a swept matrix.
  
  #######################################
  ## FILL IN THE BODY OF THIS FUNCTION ##
  #######################################
  
  rows <- dim(A)[1]
  cols <- dim(A)[2]
  
  # check if input is a square matrix
  stopifnot(rows == cols)
  
  for (k in 1:m){
    #pivot element is k
    for(i in 1:rows){
      for(j in 1:rows){
        if(i!=k & j!=k){
          A[i,j] <- A[i,j] - (A[i,k] * A[k,j])/A[k,k]
        }
      }
    }
    
    for(i in 1:rows){
      if(i != k){
        A[i,k] <- A[i,k]/A[k,k]
      }
    }
    for(j in 1:rows){
      if(j != k){
        A[k,j] <- A[k,j]/A[k,k]
      }
    }
    A[k,k] <- (-1)/A[k,k]
  }
  
  ## The output is the modified matrix A
  return(A)
  
}

#########################################################
## Function 2: Use sweep operation to find determinant ##
#########################################################

myDet <- function(A){
  
  ## Use the sweep operator to find the determinant of 
  ## the square matrix A
  #
  # A: a square matrix.
  # Returns the determinant of A.
  
  #######################################
  ## FILL IN THE BODY OF THIS FUNCTION ##
  #######################################
  
  rows <- dim(A)[1]
  cols <- dim(A)[2]
  
  # check if input is a square matrix
  stopifnot(rows == cols)
  
  Det <- 1
  for (k in 1:rows){
    #pivot element is k
    Det <- Det * A[k,k]
    for(i in 1:rows){
      for(j in 1:rows){
        if(i!=k & j!=k){
          A[i,j] <- A[i,j] - (A[i,k] * A[k,j])/A[k,k]
        }
      }
    }
    
    for(i in 1:rows){
      if(i != k){
        A[i,k] <- A[i,k]/A[k,k]
      }
    }
    for(j in 1:rows){
      if(j != k){
        A[k,j] <- A[k,j]/A[k,k]
      }
    }
    A[k,k] <- (-1)/A[k,k]
  }
  
  ## Return the determinant (a real number, aka "numeric" class)
  return(Det)
}




## ~~~~~~~~~~~~~~~~~~~~~ ##
## ~~~~~ Problem 2 ~~~~~ ##
## ~~~~~~~~~~~~~~~~~~~~~ ##  

#####################################################
## Function 3: Elementwise version of Gauss Jordan ##
#####################################################


myGaussJordan <- function(A, m){
  
  # Perform Gauss Jordan elimination on A.
  # 
  # A: a square matrix.
  # m: Number of diagonal elements to loop through.
  
  #######################################
  ## FILL IN THE BODY OF THIS FUNCTION ##
  #######################################
  
  rows <- dim(A)[1]
  
  # binding A with Identity
  B <- cbind(A,diag(rep(1,rows)))
  
  for (k in 1:m){
    #pivot element is k
    pivot <- B[k,k]
    for(j in 1:(2*rows)){
      B[k,j] <- B[k,j]/pivot
    }
    for(i in 1:rows){
      if(i!=k){
        aik <- B[i,k]
        for(j in 1:(2*rows)){
          B[i,j] <- B[i,j] - B[k,j]*aik
        }
      }
    }
  }
  
  ## Function returns the matrix B
  return(B)
  
}

####################################################
## Function 4: Vectorized version of Gauss Jordan ##
####################################################

myGaussJordanVec <- function(A, m){
  
  # Perform Gauss Jordan elimination on A.
  # 
  # A: a square matrix.
  # m: Number of diagonal elements to loop through.
  
  #######################################
  ## FILL IN THE BODY OF THIS FUNCTION ##
  #######################################
  
  rows <- dim(A)[1]
  
  # binding A with Identity
  B <- cbind(A,diag(rep(1,rows)))
  
  for (k in 1:m){
    #pivot element is k
    pivot <- B[k,k]
    B[k,] <- B[k,]/pivot
    
    for(i in 1:rows){
      if(i!=k){
        B[i,] <- B[i,] - (B[k,]*B[i,k])
      }
    }
  }
  
  ## Function returns the matrix B
  return(B)
  
}



# #######################################################
# # Optional examples (comment out before submitting!) ##
# #######################################################
# A <- matrix(c(1,2,3,7,11,13,17,21,23),3,3)
# #A <- matrix(c(1,1,2,3),2,2)
#
n = 20
A = matrix(rnorm(n*n), nrow=n)
Adim = dim(A)[1]
# #apply sweep operator on A
ptm <- proc.time()
B <- mySweep(A,Adim)
proc.time() - ptm
# B <- mySweep(A,Adim)
# # get inverse of A
# Ainv = solve(A)
# # check if A inverse matches with -B
# all.equal(-B, Ainv)
# 
# # get determinant of A using Sweep operator
# Adet <- myDet(A)
# # get determinant of A using R
# RAdet <- det(A)
# # check if Adet and RAdet are equal
# all.equal(Adet, RAdet)
# 
# # get element wise Gauss Jordan Elimination
# B <- myGaussJordan(A,Adim)
# #check if output matches with inverse of A
# all.equal(B,cbind(diag(rep(1,Adim)),solve(A)))
# 
# # get vector based Gauss Jordan Elimination
# B <- myGaussJordanVec(A,Adim)
# #check if output matches with inverse of A
# all.equal(B,cbind(diag(rep(1,Adim)),solve(A)))
