setwd("/home/nyxelio/Bureau/bureau")
data<-read.csv("hw1_data.csv", header=TRUE, sep=",")
head(data, n=10)
tail(data, n=5)

colnames(data)
head(data, n=2)
nrow(data)
tail(data, n=3)
data[(nrow(data)-3):nrow(data),]

data["47", "Ozone"]
data$Ozone[47]
data

table(is.na(data))
length(which(is.na(data)))
table(is.na(data$Ozone))

mean(data$Ozone, na.rm=TRUE)


mean(subset(data, data$Ozone > 31 & data$Temp < 90)$Solar.R, na.rm=TRUE)


mean(data$Temp[which(data$Month==6)], na.rm=TRUE)

max(data$Ozone[which(data$Month==5)], na.rm=TRUE)