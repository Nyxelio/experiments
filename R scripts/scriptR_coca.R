###################
##   Mentions   ###
###################

setwd("/home/nyxelio/Bureau/bureau/cocacola/")

topics<-c("Topic7", "Topic11", "Topic12", "Topic13", "Topic19", "Topic20", "Topic31", "Topic39", "Topic40", "Total")

data<-list.files()
weeks2015<-data.frame()
for (i in 1:length(data))
{
	data2015<-read.csv(data[i], sep=";", header=FALSE)[,c(1,11)]
	week<-data2015[which(data2015[,1] %in% topics),]
	weeks2015<-rbind(weeks2015,week)
}
#voir weeks2015


mentions<-data.frame(S1=weeks2015[which(weeks2015[,1]=="Topic7"),2],
			S2=weeks2015[which(weeks2015[,1]=="Topic11"),2],
			S3=weeks2015[which(weeks2015[,1]=="Topic12"),2],
			S4=weeks2015[which(weeks2015[,1]=="Topic13"),2],
			S5=weeks2015[which(weeks2015[,1]=="Topic19"),2],
			S6=weeks2015[which(weeks2015[,1]=="Topic20"),2],
			S7=weeks2015[which(weeks2015[,1]=="Topic31"),2],
			S8=weeks2015[which(weeks2015[,1]=="Topic39"),2],
			S9=weeks2015[which(weeks2015[,1]=="Topic40"),2])
rownames(mentions)<-paste("W", c(1:52), sep="")
#voir mentions


mentGloba<-apply(mentions,1,sum)
# ?a ne marche pas, pourquoi?
str(mentions)
#  $ S1: Factor w/ 505 levels "","0","1","10",..: 
# mes valeurs sont factors, mais on a besoin de valeurs numeric! 
mentions<-apply(mentions, 2, as.numeric)
rownames(mentions)<-paste("W", c(1:52), sep="")
mentGloba<-apply(mentions,1,sum)
#voir mentGloba


#on trouve la quantit? de toutes les mentions (en considerant tous les sujets)
allMentions<-as.numeric(as.character(weeks2015[which(weeks2015[,1]=="Total"),2]))


#% que nos mentions des 9 sujets consider? representent par rapport au total 
prop<-round((sum(mentGloba)*100)/sum(allMentions),2)






#########################
##   Campagne/Media   ###
#########################

setwd("/home/nyxelio/Bureau/bureau/")
install.packages("xlsx")
library(xlsx)
planCampaMedia<-read.xlsx("planMedia.xlsx", sheetIndex=1, header=TRUE)
#voir planCampaMedia

# Why R put an X  in the column names ?
#This is documented in ?make.names:
#Details:
#    A syntactically valid name consists of letters, numbers and the
#    dot or underline characters and starts with a letter or the dot
#    not followed by a number.  Names such as ?".2way"? are not valid,
#    and neither are the reserved words.

#    The definition of a _letter_ depends on the current locale, but
#    only ASCII digits are considered to be digits.

#    The character ?"X"? is prepended if necessary.  All invalid
#    characters are translated to ?"."?.  A missing value is translated
#    to ?"NA"?.  Names which match R keywords have a dot appended to
#    them.  Duplicated values are altered by ?make.unique?.

colnames(planCampaMedia)[3:ncol(planCampaMedia)]<-paste("W", c(1:52), sep="")


# ? partir de planCampaMedia on va obtenir le planCamp, c'est ? dire un dataset qui nous dit seulement quand une campagne est ON (sans considerer le type de media)
# planCampaMedia[,-c(1,2)] est numeric ?
str(planCampaMedia)
# no!
planCampaMedia[,-c(1,2)]<-apply(planCampaMedia[,-c(1,2)], 2, as.numeric)
# on fait la somme par semaine et par campagne
planCamp<-apply(planCampaMedia[,-c(1,2)], 2, function(x) {tapply(x, planCampaMedia$Campagne, sum)})
# remplace les valeurs superieurs ? 1 avec 1, et je fait la Matrix Transpose (pour avoir les lignes comme des semaines, comme dans les mentions)
planCamp<-t(ifelse(planCamp >= 1, 1, 0))







######################
## Invest Campa    ###
######################

invCampa<-read.xlsx("investisCampa2015.xlsx", sheetIndex=1, header=TRUE)[,-1]
colnames(invCampa)<-paste("W", c(1:52), sep="")
rownames(invCampa)<-read.xlsx("investisCampa2015.xlsx", sheetIndex=1, header=TRUE)[,1]
# est numeric ?
str(invCampa)







#################################### Analyse 1

### partie 1

matrixTemp<-c()
for (i in 1:ncol(mentions))
{
	vectorTemp<-c()
	for (j in 1:ncol(planCamp))
	{
		ON<-round((((sum(mentions[which(planCamp[,j]==1),i])/table(planCamp[,j])[["1"]])-(sum(mentions[,i])/52))/(sum(mentions[,i])/52))*100, 2)
		OFF<-round((((sum(mentions[which(planCamp[,j]==0),i])/table(planCamp[,j])[["0"]])-(sum(mentions[,i])/52))/(sum(mentions[,i])/52))*100, 2)
		vectorTemp<-c(vectorTemp,ON,OFF)
	}
	matrixTemp<-c(matrixTemp,vectorTemp)
}
campOnOff<-as.data.frame(matrix(matrixTemp, ncol(mentions), ncol(planCamp)*2, byrow=TRUE))
colnames(campOnOff)<-paste(rep(rownames(invCampa), each=2), c("ON","OFF"), sep=" ")
rownames(campOnOff)<-colnames(mentions)

campON<-campOnOff[,grep(pattern="ON", x=colnames(campOnOff), value=FALSE)]
campOFF<-campOnOff[,grep(pattern="OFF", x=colnames(campOnOff), value=FALSE)]


### partie 2

campAllMentOnOff<-c()
for (j in 1:ncol(planCamp))
{
	ON<-round((((sum(mentGloba[which(planCamp[,j]==1)])/table(planCamp[,j])[["1"]])-(sum(mentGloba)/52))/(sum(mentGloba)/52))*100, 2)
	OFF<-round((((sum(mentGloba[which(planCamp[,j]==0)])/table(planCamp[,j])[["0"]])-(sum(mentGloba)/52))/(sum(mentGloba)/52))*100, 2)
	campAllMentOnOff<-c(campAllMentOnOff,ON,OFF)
}
names(campAllMentOnOff)<-colnames(campOnOff)

campAllMentON<-campAllMentOnOff[grep(pattern="ON", x=names(campAllMentOnOff), value=FALSE)]
campAllMentOFF<-campAllMentOnOff[grep(pattern="OFF", x=names(campAllMentOnOff), value=FALSE)]




#################################### Analyse 2
#####




######################################## ANALYSE 3

weekInvTot<-apply(invCampa,2,sum)

mentionsYear<-apply(mentions,2,sum)

#co?t moyen en centimes d'euros d'une mention: vu que les mentions des 9 sujets rappresentatano environ 51% ("prop") de toutes les mentions,
#je prends en consid?ration les 51% de l'investissement
round((sum(weekInvTot)*prop)/100/sum(mentionsYear))