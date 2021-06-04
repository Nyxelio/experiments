#x<7
x <- c(4,6,5,7,10,9,4,15)
x[which(x < 7)]

#p+q
p<- c(3,5,6,8)
q <- c(3,3,3)
p+q

Age <- c(22,25,18,20)
Name <- c("James","Mathew", "Olivia", "Stella")
Gender <- c("M","M","F","F")
d <- data.frame(Age,Name,Gender)
#solutions
d[1:2,]
head(d,2)


# output ?
z<-0:9
digits <- as.character(z)
as.integer(digits)

x <- c(1,3,5,7,NA)
#solutions
#x[-5]
x[!is.na(x)]

