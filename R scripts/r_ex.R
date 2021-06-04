#q1
x <- c(3,7,8)
valid = FALSE

for(i in 1:(length(x)-1))
{
  valid = ifelse(x[i] < x[i+1], TRUE, FALSE)
}

#ou
if(is.unsorted(x) == 'FALSE'){print('TRUE')}

#q2
x <- c(3,7,8)
sort(x, decreasing = TRUE)[1]

#q3
x <- c(3,7,8)
length(x[which(x > mean(x))])
#ou
for(i in 1:length(x)){
  if(x[i] > mean(x)){
    result = result +1
  }
}

i<- 0
repeat{
  i <- i+2
  print(i)
  if(i == 10){ break }
}

#while(i< 8)

#ex
msg <- c('Bonjour')
i<- 1
repeat{
  print(msg)
  if(i == 5) {
    break;
  }
  i = i + 1
}

#q2
msg <- c('Bonjour')
i<- 1
while(i <= 6) {
  print(msg)
  i = i + 1
}

#q3
i <- 1:5
for(v in i){
  if(v == 3){
    next
  }
  print(i[v]) #or v as index == vector
}

x = c('1','2',3,3)
print(class(factor(x)))
print(factor(x))
z <- factor(c('p','q','r','p'))



frame = data.frame(Age= c(25,31,23,52,76,49,26), Height=c(177,163,190,179,163,183,164),Weight=c(57,69,83,75,70,83,53), Sex=c('F','F', 'M', 'M', "F", "M", "F"))
rownames(frame) <- c('Alex','Lilly','Mark','Oliver','Martha','Lucas','Caroline')
#ou data.frame(row.names= c('bla','bla'))
levels(frame$Sex) <- c('M','F')
frame

Working <- c('Yes', 'No','No', 'Yes', 'Yes', 'No', 'Yes')
dfa <- data.frame(row.names = c('Alex','Lilly','Mark','Oliver','Martha','Lucas','Caroline'), Working)
dfa 
dfb <- cbind(frame, dfa)
dfb
