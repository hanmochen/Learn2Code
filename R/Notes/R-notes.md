# R-notes

[TOC]

NOTES from R-intro.

2019.2.22

##  Introduction



#### Get help

```R
> help(solve)
> ?solve
> ??solve
> example(topic)
```



### R commands

- case-sensitive

#### Quit R

```R
q()
```



#### Comments

```R
#this is a comment
```



#### Executing R files

```R
source("test.R")
```



### Data commands

#### View

```R
objects()
ls()
```

#### Remove

```R
rm(x,y,z)
```



## Simple manipulations



### Vectors

#### Assignment

```R
x<-c(10.4, 5.6, 3.1, 6.4, 21.7)
# equals
assign("x", c(10.4, 5.6, 3.1, 6.4, 21.7))
c(10.4, 5.6, 3.1, 6.4, 21.7) -> x
```



if we use the command

```R
1/x
```

the reciprocals of the 5 values would be printed at the terminal but not saved.



the further assignment 

```R
y <- c(x, 0, x)
```

will create a vector $y$ with 11 numbers.



### Arithmetic

#### Basic

- Vectors can be used in arithmetic expressions, in which case the operations are performed ==element by element==.
- Vectors occurring in the same expression need ==not== all be of the same length.
- If they are not, the value of the expression is a vector with the same length as the ==longest== vector which occurs in the expression. Shorter vectors in the expression are ==recycled== as often as need be (perhaps fractionally) until they match the length of the longest vector.

example

```R
v <- 2*x + y + 1
```

The elementary arithmetic operators are the usual +, -, *, / and ^ for raising to a power.



```R
> x<-c(1,2)
> y<-c(2,3)
> x^y
[1] 1 8
> y<-c(y,1)
> x^y
[1] 1 8 1
#Warning message:
#In x^y : longer object length is not a multiple of shorter object length
```



#### Others

- **log, exp, sin, cos, tan, sqrt**
- **min,max**,**range(x)** returns **c(min(x),max(x))**
  - Note that **max** and **min** select the largest and smallest values in their arguments, even if they are given several vectors. 
  - The parallel maximum and minimum functions **pmax** and **pmin** return a vector (of length equal to their longest argument) that contains in each element the largest (smallest) element in that position in any of the input vectors.

- **sum,length,prod**

- **mean(x)**=sum(x)/length(x)

- **var(x)**=sum((x-mean(x))^2)/==(length(x)-1)==
  - If the argument to var() is an n-by-p matrix the value is a p-by-p sample covariance matrix got by regarding the rows as independent p-variate sample vectors.
- **sort()** : default increasing order
- sqrt(-17) returns NaN; **sqrt(-16+0i)** returns 0+4i



### Generating regular sequences

We can use the colon operator.

- For example **1:30** is the vector **c(1, 2, ..., 29, 30)**
- **2*1:15 is the vector c(2, 4, ..., 28, 30).**
- **:** has high priority within an expression
- The construction 30:1 may be used to generate a sequence backwards.

We can also use `seq()`

- ```R
  seq(from = 1, to = 1, by = ((to - from)/(length.out - 1)),
      length.out = NULL, along.with = NULL, ...)
  ```

A related function is `rep()` which can be used for replicating an object in various complicated ways

```R
rep(x, times = 1, length.out = NA, each = 1)
```

 `s5 <- rep(x, times=5)` will put five copies of x end-to-end in s5

`s6 <- rep(x, each=5)` repeats each element of x five times before moving on to the next.



### Logical vectors

#### Assignment

- The elements of a logical vector can have the values TRUE, FALSE, and NA (for “not available”, see below).
- The first two are often abbreviated as T and F, respectively.
  -  Note however that T and F are just variables which are set to TRUE and FALSE by default, but are not reserved words and hence can be overwritten by the user.
  -  Hence, you should always use TRUE and FALSE.

#### Operators 

- The logical operators are <, <=, >, >=, == for exact equality and != for inequality
- In addition if c1 and c2 are logical expressions, then c1 & c2 is their intersection (“and”), c1 | c2 is their union (“or”), and !c1 is the negation of c1.
- Logical vectors may be used in ordinary arithmetic, in which case they are coerced into numeric vectors, FALSE becoming 0 and TRUE becoming 1.



### Missing Values

#### NA

- In some cases the components of a vector may not be completely known. When an element or value is “not available” or a “missing value” in the statistical sense, a place within a vector may be reserved for it by assigning it the special value NA. 

- In general any operation on an NA becomes an NA.

- The function is.na(x) gives a logical vector of the same size as x with value TRUE if and only if the corresponding element in x is NA.

  ```R
  z <- c(1:3,NA); ind <- is.na(z)
  ```

  

#### NaN

- Note that there is a second kind of “missing” values which are produced by numerical computation, the so-called Not a Number, NaN, values. Examples 

```R
0/0;Inf-Inf
```

- In summary, `is.na(xx)` is TRUE both for NA and NaN values. To differentiate these, `is.nan(xx)` is only TRUE for NaNs.



### Character Vectors

#### Assignment

- Character quantities and character vectors are used frequently in R, for example as plot labels. 
- Where needed they are denoted by a sequence of characters delimited by the double quote character, e.g., "x-values", "New iteration results".
- Character strings are entered using either matching double (") or single (’) quotes, but are printed using double quotes (or sometimes without quotes).
- They use C-style escape sequences, using \ as the escape character, so \\ is entered and printed as \\, and inside double quotes " is entered as \"

- Other useful escape sequences are \n, newline, \t, tab and \b, backspace
- Character vectors may be concatenated into a vector by the c() function; examples of their use will emerge frequently.



#### paste()

- The paste() function takes an arbitrary number of arguments and concatenates them one by one into character strings.
- Any numbers given among the arguments are coerced into character strings in the evident way, that is, in the same way they would be if they were printed. 
- The arguments are by default separated in the result by a single blank character, but this can be changed by the named argument, `sep=string`, which changes it to `string`, possibly empty.

```R
labs <- paste(c("X","Y"), 1:10, sep="")
labs <- c("X1", "Y2", "X3", "Y4", "X5", "Y6", "X7", "Y8", "X9", "Y10")
```



### Index Vectors

- Subsets of the elements of a vector may be selected by appending to the name of the vector an index vector in square brackets.

#### Types

Such index vectors can be any of four distinct types.



- **A logical vector** 

  - In this case the index vector is recycled to the same length as the vector from which elements are to be selected.
  - Values corresponding to TRUE in the index vector are selected and those corresponding to FALSE are omitted.
  - `y <- x[!is.na(x)]`
  - `(x+1)[(!is.na(x)) & x>0] -> z`

- **A vector of positive integral quantities.**

  - index from 1
  - example `x[1:10]`
  - example `c("x","y")[rep(c(1,2,2,1), times=4)]`
    - get "x", "y", "y", "x" repeated four times.

- **A vector of negative integral quantities.**

  - Such an index vector specifies the values to be excluded rather than included. 
  - thus `y <- x[-(1:5)]` gives y all but the first five elements of x.

- **A vector of character strings.**

  - ```R
    fruit <- c(5, 10, 1, 20)
    names(fruit) <- c("orange", "banana", "apple", "peach")
    lunch <- fruit[c("apple","orange")]
    ```



### Other types of odjects

- **matrices** or more generally arrays are multi-dimensional generalizations of vectors
- **factors** provide compact ways to handle categorical data.
- **lists** are a general form of vector in which the various elements need not be of the same type, and are often themselves vectors or lists.
  - Lists provide a convenient way to return the results of a statistical computation.
- **data frames** are matrix-like structures, in which the columns can be of different types.
  - Think of data frames as ‘data matrices’ with one row per observational unit but with (possibly) both numerical and categorical variables.
  - Many experiments are best described by data frames: the treatments are categorical but the response is numeric.
- **functions** are themselves objects in R which can be stored in the project’s workspace. This provides a simple and convenient way to extend R.



## Objects, their modes and attributes



### Intrinsic attributes: mode and length

#### Objects and modes

- The entities R operates on are technically known as objects.
  - **Atomic** Structures: their components are all of the same type, or **mode**, namely **numeric , complex, logical, character and raw**.
- Vectors must have their values all of the same mode.
  - Note that a vector can be empty and still have a mode.
  - `e <- numeric()` makes e an empty vector structure of mode numeric



#### Lists,functions and expression

- R also operates on objects called **lists**, which are of mode list.

  - These are ordered sequences of objects which individually can be of any mode.
  - lists are known as “recursive” rather than atomic structures since their components can themselves be lists in their own right.

- The other recursive structures are those of mode **function and expression**.

- The functions `mode(object)` and` can be used to find out the mode and length of any defined structure.

- R caters for changes of mode almost anywhere

  - ```R
    z<-0:9
    digits<-as.character(z)
    d<- as.integer(digits)
    ```

    

### Changing the length of an object

- Once an object of any size has been created, new components may be added to it simply by giving it an index value outside its previous range.

```R
e <- numeric()
e[3] <- 17
```

- The first two components of which are at this point both NA.

- This automatic adjustment of lengths of an object is used often, for example in the scan() function for input.
- Conversely to truncate the size of an object requires only an assignment to do so.

```R
a <- c(1:10)
a <- a[2* 1:5]
length (a) <- 3
```



### Getting and setting attributes

- The function `attributes(object)` returns a list of all the non-intrinsic attributes currently defined for that object.
- The function `attr(object, name)` can be used to select a specific attribute.
- These functions are rarely used, except in rather special circumstances when some new attribute is being created for some particular purpose, for example to associate a creation date or an operator with an R object.
- Some care should be exercised when assigning or deleting attributes since they are an integral part of the object system used in R.



### The class of an object

- All objects in R have a class, reported by the function `class`.
- A special attribute known as the class of the object is used to allow for an object-oriented style of programming in R
  - For example if an object has class "data.frame", it will be printed in a certain way, the plot() function will display it graphically in a certain way, and other so-called generic functions such as summary() will react to it as an argument in a way sensitive to its class.
- To remove temporarily the effects of class, use the function `unclass()`. For example if `winter` has the class `"data.frame"` then
  - `unclass(winter)` will print it as an ordinary list.
-  Only in rather special situations do you need to use this facility, but one is when you are learning to come to terms with the idea of class and generic functions.



## Factors



- A factor is a vector object used to specify a discrete classification (grouping) of the components of other vectors of the same length.
- R provides both ordered and unordered factors.



### A specific example

> Suppose, for example, we have a sample of 30 tax accountants from all the states and territories of Australia 1 and their individual state of origin is specified by a character vector of state mnemonics as
>
> ```R
> state <- c("tas", "sa", "qld", "nsw", "nsw", "nt", "wa", "wa", "qld", "vic", "nsw", "vic", "qld", "qld", "sa", "tas", "sa", "nt", "wa", "vic", "qld", "nsw", "nsw", "wa", "sa", "act", "nsw", "vic", "vic", "act")
> ```
>
> Notice that in the case of a character vector, “sorted” means sorted in alphabetical order.
>
> - A factor is similarly created using the `factor()` function:
>
> ```R
> statef <- factor(state)
> ```
>
> - The `print()` function handles factors slightly differently from other objects:
>
> ```R
> > statef
> 
> [1] tas sa qld nsw nsw nt wa wa qld vic nsw vic qld qld sa
> 
> [16] tas sa nt wa vic qld nsw nsw wa sa act nsw vic vic act 
> Levels: act nsw nt qld sa tas vic wa
> ```
>
> - To find out the levels of a factor the function `levels()` can be used.



### The function `tapply()` and ragged arrays

To continue the previous example, suppose we have the incomes of the same tax accountants in another vector (in suitably large units of money)

```R
incomes <- c(60, 49, 40, 61, 64, 60, 59, 54, 62, 69, 70, 42, 56, 61, 61, 61, 58, 51, 48, 65, 49, 49, 41, 48, 52, 46, 59, 46, 58, 43)
```

To calculate the sample mean income for each state we can now use the special function `tapply()`:

```R
incmeans <- tapply(incomes, statef, mean)
```

giving a means vector with the components labelled by the levels 

```
act nsw nt qld sa tas vic wa

44.500 57.333 55.500 53.600 55.000 60.500 56.000 52.250
```

The function tapply() is used to apply a function, here `mean()`, to each group of components of the first argument, here incomes, defined by the levels of the second component, here `statef` ,as if they were separate vector structures. The result is a structure of the same length as the levels attribute of the factor containing the results.

Suppose further we needed to calculate the standard errors of the state income means. 

```R
stdError <- function(x) sqrt(var(x)/length(x))
incster <- tapply(incomes, statef, stdError)
```

- The combination of a vector and a labelling factor is an example of what is sometimes called a ragged array, since the subclass sizes are possibly irregular.



### Ordered factors

- The levels of factors are stored in **alphabetical order**, or in the order they were specified to factor if they were specified explicitly.
- Sometimes the levels will have a natural ordering that we want to record and want our statistical analysis to make use of.The `ordered()` function creates such ordered factors but is otherwise identical to factor
- For most purposes the only difference between ordered and unordered factors is that the former are printed showing the ordering of the levels, but **the contrasts generated for them in fitting linear models are different.**



## Arrays and matrices



### Arrays

- An array can be considered as a multiply subscripted collection of data entries, for example numeric.

- R allows simple facilities for creating and handling arrays, and in particular the special case of matrices.

- A **dimension** vector is a vector of non-negative integers. If its length is k then the array is k-dimensional

  - The dimensions are indexed from one up to the values given in the dimension vector.

- A vector can be used by R as an array only if it has a dimension vector as its `dim` attribute. Suppose, for example, z is a vector of 1500 elements. 

  - The assignment

    ```R
    dim(z) <- c(3,5,100)
    ```

    gives it the dim attribute that allows it to be treated as a 3 by 5 by 100 array.

- Other functions such as `matrix()` and `array()` are available for simpler and more natural looking assignments.

- ==column major order== : the first subscript moving fastest and the last subscript slowest

  - For example,if the dimension vector for an array, say `a`, is `c(3,4,2)` then there are `3 × 4 × 2 = 24` entries in a and the data vector holds them in the order `a[1,1,1], a[2,1,1], ..., a[2,4,2], a[3,4,2]`.

### Array indexing

- Individual elements of an array may be referenced by giving the name of the array followed by the subscripts in square brackets, separated by commas.
- More generally, subsections of an array may be specified by giving a sequence of index vectors in place of subscripts
- If any index position is given an empty index vector, then **the full range of that subscript** is taken, for example `a[2,,]`



### Index matrices

- As well as an index vector in any subscript position, a matrix may be used with a single index matrix in order either to assign a vector of quantities to an irregular collection of elements in the array, or to extract an irregular collection as a vector.
- In the case of a doubly indexed array, an index matrix may be given consisting of two columns and as many rows as desired. The entries in the index matrix are the row and column indices for the doubly indexed array.

#### Example

> Suppose for example we have a 4 by 5 array X and we wish to do the following:
>
> - Extract elements X[1,3], X[2,2] and X[3,1]
> - Replace these entries in the array X by zeroes.
>
> In this case we need a 3 by 2 subscript array, as in the following example.
>
> ```R
> > x <- array(1:20, dim=c(4,5)) # Generate a 4 by 5 array.
> > x
>      [,1] [,2] [,3] [,4] [,5]
> [1,]    1    5    9   13   17
> [2,]    2    6   10   14   18
> [3,]    3    7   11   15   19
> [4,]    4    8   12   16   20
> > i <- array(c(1:3,3:1), dim=c(3,2))
> > i # i is a 3 by 2 index array.
>      [,1] [,2]
> [1,]    1    3
> [2,]    2    2
> [3,]    3    1
> > x[i] # Extract those elements
> 9 6 3 
> > x[i] <- 0 # Replace those elements by zeros.
> > x 
>      [,1] [,2] [,3] [,4] [,5]
> [1,]    1    5    0   13   17
> [2,]    2    0   10   14   18
> [3,]    0    7   11   15   19
> [4,]    4    8   12   16   20
> ```



#### Example 2

As a less trivial example, suppose we wish to generate an (unreduced) design matrix for a block design defined by factors blocks (b levels) and varieties (v levels). Further suppose there are n plots in the experiment. We could proceed as follows:

```R
> Xb <- matrix(0, n, b)
> Xv <- matrix(0, n, v)
> ib <- cbind(1:n, blocks)
> iv <- cbind(1:n, varieties)
> Xb[ib] <- 1
> Xv[iv] <- 1
> X <- cbind(Xb, Xv)
```

To construct the incidence matrix, N say, we could use

```R
N <- crossprod(Xb, Xv)
```

However a simpler direct way of producing this matrix is to use `table():`

```R
N <- table(blocks, varieties)
```



### The `array()` function

As well as giving a vector structure a dim attribute, arrays can be constructed from vectors by the array function, which has the form

```R
Z <- array(data_vector, dim_vector);
```

However if h is shorter than 24, its values are recycled from the beginning again to make it up to size 24.As an extreme but common example,

```R
Z <- array(0, c(3,4,2))
```

makes Z an array of all zeros.

Arrays may be used in arithmetic expressions and the result is an array formed by elementby-element operations on the data vector. The dim attributes of operands generally need to be the same, and this becomes the dimension vector of the result.



#### The recycling rule

- The expression is scanned from left to right.
- Any short vector operands are extended by recycling their values until they match the size of any other operands.
- As long as short vectors and arrays only are encountered, the arrays must all have the same dim attribute or an error results.
- Any vector operand longer than a matrix or array operand generates an **error**.
- If array structures are present and no error or coercion to vector has been precipitated, the result is an array structure with the common dim attribute of its array operands.



### The outer product of two arrays

- An important operation on arrays is the outer product.

  ```
  ab <- a %o% b
  ```

- An alternative is

  ```R
  ab <- outer(a, b, "*")
  ```

  

#### An example

**Determinants of 2 by 2 single-digit matrices**

As an artificial but cute example, consider the determinants of 2 by 2 matrices [a, b; c, d] where each entry is a non-negative integer in the range 0, 1, . . . , 9, that is a digit.

```R
d <- outer(0:9, 0:9)
fr <- table(outer(d, d, "-"))
plot(fr, xlab="Determinant", ylab="Frequency")
```

- Notice that `plot()` here uses a histogram like plot method, because it “sees” that fr is of class "table".



### Generalized transpose of an array

- The function `aperm(a, perm)` may be used to permute an array, a.
  - The argument `perm` must be a permutation of the integers {1, . . . , k}, where k is the number of subscripts in a.
  - The result of the function is an array of the same size as `a` but with old dimension given by `perm[j]` becoming the new `j-th` dimension.
- The easiest way to think of this operation is as a generalization of transposition for matrices.
  - `B <- aperm(A, c(2,1))`
  - `B <- t(A)`



### Matrix facilities

R contains many operators and functions that are available only for matrices.

- For example `t(X)` is the matrix transpose function
- The functions `nrow(A)` and `ncol(A)` give the number of rows and columns in the matrix A respectively.



#### Matrix multiplication

- The operator `%*%` is used for matrix multiplication.
  - An n by 1 or 1 by n matrix may of course be used as an n-vector if in the context such is appropriate.
  - Conversely, vectors which occur in matrix multiplication expressions are automatically promoted either to **row or column vectors,** whichever is multiplicatively **coherent**, if possible  (although this is not always unambiguously possible)
- For example, A and B are square matrices of the same size,
  - `A * B` is the matrix of element by element products
  - `A %*% B` is the matrix product
- If x is a vector,then
  - `x %*% A %*% x` is a quadratic form
  -  Note that `x %*% x` is ambiguous,as it could mean either $x^Tx$ or $xx^T$ if $x$ is a $n\times 1​$ matrix.
  - In such cases the **smaller** matrix seems implicitly to be the interpretation adopted, so the scalar $x^T x$ is in this case the result.
  - The matrix $xx^T$ may be calculated either by `cbind(x) %*% x` or` x %*% rbind(x)`  since the result of `rbind()` or `cbind()` is always a matrix. 
  - However, the best way to compute $x^T x$ or $xx^T $ is `crossprod(x)` or `x %o% x` respectively.
- The function `crossprod()` forms “crossproducts”, meaning that `crossprod(X, y)` is the same as `t(X) %*% y` but the operation is **more efficient**.
  - If the second argument to `crossprod()` is omitted it is taken to be the same as the first.
- The meaning of `diag()` depends on its argument. 
  - `diag(v)`, where `v` is a vector, gives a diagonal matrix with elements of the vector as the diagonal entries (others 0)
  - On the other hand `diag(M),` where M is a matrix, gives the vector of main diagonal entries of M.
  - Also, somewhat confusingly, if k is a single numeric value then diag(k) is the k by `k` identity matrix $I_{n\times n}$!

#### Linear equations and inversion

- Solving linear equations is the inverse of matrix multiplication.
- In R,`solve(A,b` gives the answer $x$ such that $Ax=b$
- $A^{-1}$ can be computed by `solve(A)`
- Numerically, it is both inefficient and potentially unstable to compute `x <- solve(A) %*% b` instead of `solve(A,b)`.



#### Eigenvalues and eigenvectors

The function `eigen(Sm)` calculates the eigenvalues and eigenvectors of a **symmetric** matrix Sm. The result of this function is a list of two components named values and vectors. 

```R
ev <- eigen(Sm)
evals <- eigen(Sm)$values
```

- Then ev\$val is the vector of eigenvalues of Sm and ev$vec is the matrix of corresponding eigenvectors.

For large matrices it is better to avoid computing the eigenvectors if they are not needed by using the expression

```R
evals <- eigen(Sm, only.values = TRUE)$values
```



#### Singular value decomposition and determinants

- The function `svd(M)` takes an arbitrary matrix argument, M, and calculates the singular value decomposition of M.