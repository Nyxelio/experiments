setwd("/home/nyxelio/Bureau/bureau")
data<-read.csv("us-500.csv", header=TRUE, sep=",")

#q1
str(data)

#q2
nrow(subset(data, data$state == "CA" | data$state == "TX"))

#q3
nrow(subset(data, first_name == "Erick" & state == "IL"))

#q4
data$last_name <- toupper(data$last_name)

#q5
name <- paste(data$first_name, data$last_name, sep=" ")
name

#q6
countyInit <- substr(data$county, start=1, stop=3)
countyInit

#q7
phone1 <- gsub('-','', data$phone1)

#q8
contacts <- data.frame(name=name,phone1=phone1,email=data$email)

#q9
length(grep("[yY]",contacts$name,TRUE))

#q10
length(grep("@gmail",contacts$email,TRUE))
