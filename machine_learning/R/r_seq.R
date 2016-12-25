seq(from=2, to=13, by= 3)

# définit un vecteur de taille length.out et divise la sequence:
# 9 18 27 36 45 54 63 72 81 90
seq(from=9, to=90, length.out = 10)

x<-c(2,8,7,3,1)
sort(x)
sort(x, decreasing = TRUE)

x<-c(2,8,7,3,1)
order(x)

order(x, decreasing = TRUE)

#df[order(df$note),]

data <- mtcars

subset(data, data$mpg)

data[which(data$mpg > 15 & data$mpg < 20),]

data[which(data$cyl == 6 & data$am != 0),]

data[which(data$gear == 4 | data$carb == 4),]

data[seq(from=2, to=nrow(data), by=2),]
#ou
data[c(F,T),]

data[seq(from=4, to=nrow(data), by=4),]$mpg = 0
#ou
data$mpg[c(F,F,F,T)] <- 0


data[which(data$am == 0),]$am = 2


x <- as.Date("2016-03-24")
class(x)
x+1

y <- as.Date(c('02/07/10', '02/23/10', '02/08/10', '02/14/10'), '%m/%d/%y')
mean(y)
max(y)
as.character(y)

as.Date("07/19/1998", format="%m/%d/%Y")
format(as.Date("07/19/1998", format="%m/%d/%Y"), "%m/%d/%Y")

#if(N*5 > 4){
#}else
#{}
#ifelse(N*5 > 4, 'hth','fff')
#for(i in 1:4){
#  print y[i]
#}

#for (i in 1:length(levels(test$Name)))

#cat("the absolute value","bla")
