my_matrix <- matrix(1:6, nrow=3, ncol=2)
my_matrix

length(my_matrix[1,1])

#retourne dimension
dim(my_matrix)

#matrix
my_matrix[1,2]

#toute la 1ere ligne
my_matrix[1,]

#toute la 1ere colonne
my_matrix[,1]

#rbind = row bind, créer une matrice avec les vecteurs en ligne
x<-c(1,2,3,4,5,6)
y<-c(10,20,30,40,50,60)
z<- rbind(x,y)

#cbind = column bind, créer une matrice avec les vecteurs en colonne
x<-c(1,2,3,4,5,6)
y<-c(10,20,30,40,50,60)
z<- cbind(x,y)
z

df<- data.frame(nom=c("sophie", "jean", "paul", "marc"), note=c(20,16,18,10))
df
dim(df)
nrow(df)
ncol(df)
colnames(df)
rownames(df)
rownames(df) <- c("A","B","C","D")
df

#condition, retourne les lignes où la première colonne contient sophie
df[which(df[,1]=="sophie"),]
df[which(df$nom=="sophie"),]
subset(df, df$nom=="sophie")

str(df)

mean(df$note)
mean(df$note, na.rm=TRUE)

##Exercices
x<-4
class(x) #numeric

x<-c(4,"a",TRUE)
class(x) #character

x<-c(1,3,5)
y<-c(3,2,10)
z<-cbind(x,y)
class(z) #matrix

x<-c(17,14,4,5,13,12,10)
x
x[which(x>10)] <- 4
x
