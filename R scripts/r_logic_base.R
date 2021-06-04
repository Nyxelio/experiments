p<- c(2,7,8)
q<-c("A","B","C")
x<- list(p,q)
x[2]
x
x[[2]]

w<- c(2,7,8)
v<- c("A","B","C")
x<- list(w,v)
x[[2]][1] <- "K"
x

a<- list("x"=5, "y"=10, "z"=15)
a
sum(unlist(a))

newlist <- list(a=1:10, b="salut", c="a bientot")
newlist$a <- newlist$a +1


b<- list(a=1:10, c="hello", d="aa")
b$a[-2]

x<- list(a=5:10, c="hello",d="aa")
x$z <- "new item"
x

y <- list("a","b","c")
names(y) <- c("one","two", "three")
y

x <- list(y=1:10, t="Salut", f="TT", r=5:20)
length(x$r)