# Exercise 1
f.sum <- function (x, y) 
{
  r <- x + y
  r
}
f.sum(5, 10)



# Exercise 2 
f.exists <- function (v, x) 
{
  exist <- FALSE
  i <- 1
  while (i <= length (v) & !exist) 
	{
		if (v[i] == x) 
		{
			exist <- TRUE
    		}
  		i <- 1 + i
  	}
  exist
}
f.exists(c(1:10), 10)
f.exists(c(9, 3, 1), 10)



# Exercise 3
f.class <- function (df) 
{
	for (i in 1:ncol(df)) 
	{
		cat(names(df)[i], "is", class(df[, i]), "\n")
  	}
}
f.class(cars)



# Exercise 4 
f.uniq <- function (v) 
{
  s <- c()
  for(i in 1:length(v)) 
	{
		if(sum(v[i] == s) == 0) 
		{
			s <- c(s, v[i])
    		}
  	}
  s
}
f.uniq(c(9, 9, 1, 1, 1, 0))



# Exercise 5 
f.count <- function (v, x) 
{
  count <- 0
  for (i in 1:length(v)) 
	{
		if (v[i] == x) 
		{
			count <- count + 1
    		}
  	}
  count
}
f.count(c(1:9, rep(10, 100)), 10)



# Exercise 6 
msdme<- function(x, med=FALSE) 
{
  mean <- round(mean(x), 1)
  stdv <- round(sd(x), 1)
  cat("Mean is:", mean, ", SD is:", stdv, "\n")
  if(med) 
	{
		median <- median(x)
		cat("Median is:", median , "\n")
  	}
}
msdme(1:10, med=TRUE)