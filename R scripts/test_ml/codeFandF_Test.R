######QUESTION 1
######A partir des fichiers .csv, arrangez les donn?es dans un seul dataframe (nommez-le <dataLigue1>) en les mettant  
######en ordre temporel (? partir de la premi?re journ?e de la saison 2007/08 jusqu'? la derni?re journ?e de la saison 2016/17), 
######et en consid?rant seulement les 6 variables suivantes : Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR. 
######Pour ces variables, conservez les m?mes noms (c'est ? dire, Date, HomeTeam, AwayTeam, FTHG, FTAG et FTR).



######QUESTION 2
######Pour les variables cat?gorielles qui en ont besoin, enlevez les ?empty levels? (dans R : "").



#####QUESTION 3
#####V?rifiez la coh?rence entre les variables FTHG et FTAG et la variable FTR. 
#####Si besoin, faites les corrections opportunes directement sur le dataframe ?dataLigue1? 
#####(ne modifiez pas les fichiers .csv !). PS : Pour v?rifier les r?sultats : 
#####https://www.fff.fr/championnats/fff/federation-francaise-de-football/2016/327795-ligue-1/phase-1/poule-1/derniers-resultats



#####Ex?cutez le code suivant 
teams<-sort(unique(dataLigue1$HomeTeam))
dataLigue1$home.team<-c()
dataLigue1$away.team<-c()
for(k in 1:nrow(dataLigue1)) 
{
  dataLigue1$home.team[k]<-match(dataLigue1$HomeTeam[k],teams)
}
for(k in 1:nrow(dataLigue1))
{
  dataLigue1$away.team[k]<-match(dataLigue1$AwayTeam[k],teams)
}

# Expliquer le code:


#####QUESTION 4
#####V?rifiez la nouvelle structure du dataframe ?dataLigue1?. 
#####Cr?ez un dataset d'apprentissage en consid?rant les premi?res 7 saisons. 
#####Appelez-le ?dataTraining?.



#####Ex?cutez le code suivant 
#####TRAINING
mu<-0.001
a<-rep(0.001,length(teams))
b<-rep(0.001,length(teams))
tau<-0.001
theta<-c()
for(i in 1:length(teams))
{
  theta<-c(theta,a[i],b[i])
}
theta<-c(theta,mu,tau)
loglik.final<- function(theta,i,j,n.teams,home.goals,away.goals)
{
  a.i <- theta[2*i-1]
  b.i <- theta[2*i]
  a.j <- theta[2*j-1]
  b.j <- theta[2*j]
  mu  <- theta[2*n.teams+1]
  tau <- theta[2*n.teams+2]
  lambda.home <- exp(mu+ a.i + b.j + tau)
  lambda.away <- exp(mu+ a.j + b.i)
  loglik <- sum(dpois(home.goals,lambda.home,log=T)) + sum(dpois(away.goals,lambda.away,log=T))
  return(-loglik) 
}
est.test<-optim(c(rep(0.001,length(theta))), loglik.final, n.teams=length(teams), 
                 i=dataTraining$home.team, j=dataTraining$away.team, 
                 home.goals=dataTraining$FTHG, away.goals=dataTraining$FTAG, method = "L-BFGS-B")
#####END TRAINING

# Expliquer le code:


#####QUESTION 5
#####Cr?ez un dataset de test en consid?rant les saisons 2014/15, 2015/16 et 2016/17. 
#####Appelez-le ?dataTesting?.



#####Ex?cutez le code suivant 
#####TESTING
n.teams<-length(teams)
pred<-c()
for (k in 1:nrow(dataTesting))
{
  l.x<-exp(est.test$par[2*n.teams+1] + est.test$par[2*dataTesting$home.team[k]-1] + est.test$par[2*dataTesting$away.team[k]] + est.test$par[2*n.teams+2])
  l.y<-exp(est.test$par[2*n.teams+1] + est.test$par[2*dataTesting$away.team[k]-1] + est.test$par[2*dataTesting$home.team[k]])
  v1<-c(0:max(dataLigue1$FTHG))
  v2<-c(0:max(dataLigue1$FTAG))
  prob.i<-c()
  prob.j<-c()
  for (i in 2:(max(dataLigue1$FTHG)+1))
  {
    for (j in 1:(i-1))
    { 
      if (j>(max(dataLigue1$FTAG)+1)) break
      prob.j[j]<-dpois(v1[i],l.x,log=F)*dpois(v2[j],l.y,log=F)
    }
    prob.i[i]<-sum(prob.j, na.rm=T) 
  }
  home<-sum(prob.i[2:(max(dataLigue1$FTHG)+1)])
  prob.i<-c()
  prob.j<-c()
  for (j in 2:(max(dataLigue1$FTAG)+1))  
  {
    for (i in 1:(j-1)) 
    {
      prob.i[i]<-dpois(v1[i],l.x,log=F)*dpois(v2[j],l.y,log=F) 
    }
    prob.j[j]<-sum(prob.i, na.rm=T) 
  }
  away<-sum(prob.j[2:(max(dataLigue1$FTAG)+1)])
  draw<-1-home-away
  pred<-c(pred,home,draw,away) 
}
predictions.test<-matrix(pred,ncol=3,byrow=TRUE)
dpred.test<-data.frame(home.team=dataTesting$HomeTeam, away.team=dataTesting$AwayTeam,
                  home.win=predictions.test[,1], draw=predictions.test[,2],
                  away.win=predictions.test[,3], result=dataTesting$FTR)
#####END TESTING

# Expliquer le code:


#####QUESTION 6
#####Calculez la pr?cision (en pourcentage) du mod?le.



#####Ex?cutez le code suivant 
est.final<-optim(c(rep(0.001,length(theta))), loglik.final, 
                 n.teams=length(teams), i=dataLigue1$home.team, j=dataLigue1$away.team, 
                 home.goals=dataLigue1$FTHG, away.goals=dataLigue1$FTAG, method = "L-BFGS-B")

# Expliquer le code:


#####QUESTION 7
#####Cr?ez le dataframe ?next.day? qui comprend deux variables : ?HomeTeam?, qui repr?sente les ?quipes 
#####qui jouent ? la maison dans la prochaine journ?e de Ligue 1, et ?AwayTeam?, qui repr?sente les ?quipes 
#####qui jouent ? l'ext?rieur. Rappelez-vous : 
#####1) deux ?quipes qui jouent dans le m?me match devront ?tre sur la m?me ligne ; 
#####2) les ?quipes devront ?tre ?crites dans le m?me format vu dans les fichiers .csv . 



#####Ex?cutez le code suivant 
next.day$home.team<-c()
next.day$away.team<-c()
for(k in 1:nrow(next.day))
{
  next.day$home.team[k]<-match(next.day$HomeTeam[k],teams)
}
for(k in 1:nrow(next.day)) 
{
  next.day$away.team[k]<-match(next.day$AwayTeam[k],teams)
}

# Expliquer le code:


#####QUESTION 8
#####En appliquant la m?me m?thodologie vue dans la partie ?TESTING? du code, calculez les probabilit?s 
#####?home.win?, ?draw? et ?away.win? des 10 matches de la prochaine journ?e de Ligue 1. 
#####Sauvez les r?sultats dans le dataframe ?dpred? qui devra inclure 5 variables : ?HomeTeam?, ?AwayTeam?, 
#####et les 3 probabilit?s calcul?es. 