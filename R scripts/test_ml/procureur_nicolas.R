setwd("/home/nyxelio/Projects/R scripts/test_ml/Ligue1")

######QUESTION 1
######A partir des fichiers .csv, arrangez les donn?es dans un seul dataframe (nommez-le <dataLigue1>) en les mettant  
######en ordre temporel (? partir de la premi?re journ?e de la saison 2007/08 jusqu'? la derni?re journ?e de la saison 2016/17), 
######et en consid?rant seulement les 6 variables suivantes : Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR. 
######Pour ces variables, conservez les m?mes noms (c'est ? dire, Date, HomeTeam, AwayTeam, FTHG, FTAG et FTR).

# charge les fichiers
data <- list.files()
dataLigue1 <- data.frame()

for (i in 1:length(data))
{
  dataLigue1<-rbind(dataLigue1,read.csv(data[i], sep=",", header=TRUE)[,c(2:7)])
}

# Enleve les lignes vides
dataLigue1 <- dataLigue1[which(dataLigue1$HomeTeam != "" & dataLigue1$AwayTeam != ""),]


######QUESTION 2
######Pour les variables cat?gorielles qui en ont besoin, enlevez les ?empty levels? (dans R : "").
dataLigue1$FTR <- factor(dataLigue1$FTR)
dataLigue1$HomeTeam <- factor(dataLigue1$HomeTeam)
dataLigue1$AwayTeam <- factor(dataLigue1$AwayTeam)
dataLigue1$Date <- factor(dataLigue1$Date)
str(dataLigue1)


#####QUESTION 3
#####V?rifiez la coh?rence entre les variables FTHG et FTAG et la variable FTR. 
#####Si besoin, faites les corrections opportunes directement sur le dataframe ?dataLigue1? 
#####(ne modifiez pas les fichiers .csv !). PS : Pour v?rifier les r?sultats : 
#####https://www.fff.fr/championnats/fff/federation-francaise-de-football/2016/327795-ligue-1/phase-1/poule-1/derniers-resultats

# on trouve les lignes en erreurs
dataLigue1[which(!((dataLigue1$FTHG > dataLigue1$FTAG & dataLigue1$FTR == 'H') | (dataLigue1$FTHG < dataLigue1$FTAG & dataLigue1$FTR == 'A') | (dataLigue1$FTHG == dataLigue1$FTAG & dataLigue1$FTR == 'D'))),]

#         Date  HomeTeam AwayTeam FTHG FTAG FTR
#3509 16/10/16 Marseille     Metz    0    0   H
#3517 22/10/16      Lyon Guingamp    1    0   A
#3529 30/10/16 Marseille Bordeaux    1    0   D

# on réajuste les scores
dataLigue1[which(dataLigue1$Date == "16/10/16" & dataLigue1$HomeTeam == "Marseille" & dataLigue1$AwayTeam == "Metz"),]$FTHG <- 1
dataLigue1[which(dataLigue1$Date == "22/10/16" & dataLigue1$HomeTeam == "Lyon" & dataLigue1$AwayTeam == "Guingamp"),]$FTAG <- 3
dataLigue1[which(dataLigue1$Date == "30/10/16" & dataLigue1$HomeTeam == "Marseille" & dataLigue1$AwayTeam == "Bordeaux"),]$FTHG <- 0



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
# Nous récupérons d'abord les noms des équipes.
# Ensuite pour chaque ligne, nous indiquons dans la variable home.team le numéro de l'équipe à domicile et dans away.teamle numéro de l'équipe à l'extérieur.
# Ce numéro est extrait de l'emplacement du nom de l'équipe, dans le vecteur teams

#####QUESTION 4
#####V?rifiez la nouvelle structure du dataframe ?dataLigue1?. 
#####Cr?ez un dataset d'apprentissage en consid?rant les premi?res 7 saisons. 
#####Appelez-le ?dataTraining?.
dataLigue1[which(dataLigue1$Date == '17/05/2014'),]
dataTraining <- dataLigue1[1:2660,]
str(dataTraining)

#####Ex?cutez le code suivant 
#####TRAINING
# Set mu
mu<-0.001
# Set les vecteurs a et b, avec 36 enregistrements (le nombre d'équipes) identiques
a<-rep(0.001,length(teams))
b<-rep(0.001,length(teams))
# Set tau
tau<-0.001
# Set theta, pour chaque rencontre (une équipe contre une autre)
theta<-c()
for(i in 1:length(teams))
{
  theta<-c(theta,a[i],b[i])
}
theta<-c(theta,mu,tau)
# La méthode loglik.final calcule la corrélation entre les équipes en prenant en paramètre chaque rencontre.
# Elle calcule pour cela le lambda home et lamba away, qui sont les moyennes pour l'équipe (home ou away), pondérés par la constante mu et par tau (pour prendre en compte une équipe jouant à domicile)
# Nous reconnaissons le modèle Dixon et Coles adapté au low-scoring matches.
loglik.final<- function(theta,i,j,n.teams,home.goals,away.goals)
{
  a.i <- theta[2*i-1]
  b.i <- theta[2*i]
  a.j <- theta[2*j-1]
  b.j <- theta[2*j]
  mu  <- theta[2*n.teams+1]
  tau <- theta[2*n.teams+2]
  # ici a et b représentent les paramètres d'attaque et de défense.
  lambda.home <- exp(mu+ a.i + b.j + tau)
  lambda.away <- exp(mu+ a.j + b.i)
  # distribution de poisson retournant la dépendance entre les équipes
  loglik <- sum(dpois(home.goals,lambda.home,log=T)) + sum(dpois(away.goals,lambda.away,log=T))
  return(-loglik) 
}
# La méthode optim optimise le jeu de données en appliquant des contraintes aux bornes (via la méthode L-BFGS-B). Elle invoque également la fonction loglik
est.test<-optim(c(rep(0.001,length(theta))), loglik.final, n.teams=length(teams), 
                 i=dataTraining$home.team, j=dataTraining$away.team, 
                 home.goals=dataTraining$FTHG, away.goals=dataTraining$FTAG, method = "L-BFGS-B")
#####END TRAINING


#####QUESTION 5
#####Cr?ez un dataset de test en consid?rant les saisons 2014/15, 2015/16 et 2016/17. 
#####Appelez-le ?dataTesting?.

dataTesting <- dataLigue1[2661:nrow(dataLigue1),]


#####Ex?cutez le code suivant 
# En fonction des corrélations que nous avons établit précédemment, nous calculons les probabilités que l'une des équipes gagnent, ou match nul 
#####TESTING
n.teams<-length(teams)
pred<-c()
for (k in 1:nrow(dataTesting))
{
  l.x<-exp(est.test$par[2*n.teams+1] + est.test$par[2*dataTesting$home.team[k]-1] + est.test$par[2*dataTesting$away.team[k]] + est.test$par[2*n.teams+2])
  l.y<-exp(est.test$par[2*n.teams+1] + est.test$par[2*dataTesting$away.team[k]-1] + est.test$par[2*dataTesting$home.team[k]])
  # vecteurs avec le nombre max de buts marqués par les deux équipes
  v1<-c(0:max(dataLigue1$FTHG))
  v2<-c(0:max(dataLigue1$FTAG))
  prob.i<-c()
  prob.j<-c()
  # calcule de la probabilité de l'équipe à domicile gagnante
  for (i in 2:(max(dataLigue1$FTHG)+1))
  {
    for (j in 1:(i-1))
    { 
      if (j>(max(dataLigue1$FTAG)+1)) break
      # produits de la probabilité que l'équipe à domicile marque le nombre de but v1[i] et que l'équipe extérieure marque j, en gardant toujours l'équipe à domicile gagnante. 
      prob.j[j]<-dpois(v1[i],l.x,log=F)*dpois(v2[j],l.y,log=F)
    }
    # somme des distributions de poisson précédentes
    prob.i[i]<-sum(prob.j, na.rm=T) 
  }
  home<-sum(prob.i[2:(max(dataLigue1$FTHG)+1)])
  prob.i<-c()
  prob.j<-c()
  # le calcul inverse: probabilité que l'équipe adverse gagne
  for (j in 2:(max(dataLigue1$FTAG)+1))  
  {
    for (i in 1:(j-1)) 
    {
      # probabilité que l'équipe extérieure gagne avec le nombre de buts v1[i]
      prob.i[i]<-dpois(v1[i],l.x,log=F)*dpois(v2[j],l.y,log=F) 
    }
    prob.j[j]<-sum(prob.i, na.rm=T) 
  }
  away<-sum(prob.j[2:(max(dataLigue1$FTAG)+1)])
  # Le match nul est la probabilité restante
  draw<-1-home-away
  pred<-c(pred,home,draw,away) 
}
predictions.test<-matrix(pred,ncol=3,byrow=TRUE)
# retourne un dataframe avec les rencontres et les 3 pourcentages prédits
dpred.test<-data.frame(home.team=dataTesting$HomeTeam, away.team=dataTesting$AwayTeam,
                  home.win=predictions.test[,1], draw=predictions.test[,2],
                  away.win=predictions.test[,3], result=dataTesting$FTR)
#####END TESTING


#####QUESTION 6
#####Calculez la pr?cision (en pourcentage) du mod?le.
good_result = 0

for(i in 1:nrow(dataTesting))
{
  label = dataTesting[i,]$FTR

  #selon les prédictions nous en déduisons le résultat du match 
  if((dpred.test[i,]$draw > dpred.test[i,]$home.win) & (dpred.test[i,]$draw > dpred.test[i,]$away.win))
  {
    # match nul
   pred_res = 'D' 
  }
  else if(dpred.test[i,]$home.win > dpred.test[i,]$away.win){
    # équipe a domicile gagnante
    pred_res = 'H'
  }
  else{
    # équipe adverse gagnante
    pred_res = 'A'
  }
  
  #nous comparons avec le résultat réel:
  if(pred_res == label)
  {
    good_result = good_result + 1
  }
}

# pour l'avoir en pourcentage
precision = good_result / nrow(dataTesting) * 100
cat(precision, '%')


#####Ex?cutez le code suivant 
# retourne les corrélations
est.final<-optim(c(rep(0.001,length(theta))), loglik.final, 
                 n.teams=length(teams), i=dataLigue1$home.team, j=dataLigue1$away.team, 
                 home.goals=dataLigue1$FTHG, away.goals=dataLigue1$FTAG, method = "L-BFGS-B")


#####QUESTION 7
#####Cr?ez le dataframe ?next.day? qui comprend deux variables : ?HomeTeam?, qui repr?sente les ?quipes 
#####qui jouent ? la maison dans la prochaine journ?e de Ligue 1, et ?AwayTeam?, qui repr?sente les ?quipes 
#####qui jouent ? l'ext?rieur. Rappelez-vous : 
#####1) deux ?quipes qui jouent dans le m?me match devront ?tre sur la m?me ligne ; 
#####2) les ?quipes devront ?tre ?crites dans le m?me format vu dans les fichiers .csv . 

next.day <- data.frame(HomeTeam = c('Montpellier', 'Monaco', 'Dijon', 'Nantes', 'Lyon', 'Bordeaux', 'Angers', 'Caen', 'Metz', 'Paris SG'),
                       AwayTeam = c('Marseille', 'Nancy', 'Guingamp','Toulouse', 'Bastia', 'Lorient', 'Lille', 'Nice', 'St Etienne', 'Rennes'))



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

# Le code rajoute l'etiquette de l'équipe que nous avions précédemment utilisée afin de pouvoir les comptabiliser.


#####QUESTION 8
#####En appliquant la m?me m?thodologie vue dans la partie ?TESTING? du code, calculez les probabilit?s 
#####?home.win?, ?draw? et ?away.win? des 10 matches de la prochaine journ?e de Ligue 1. 
#####Sauvez les r?sultats dans le dataframe ?dpred? qui devra inclure 5 variables : ?HomeTeam?, ?AwayTeam?, 
#####et les 3 probabilit?s calcul?es. 

n.teams<-length(teams)
pred.next<-c()
for (k in 1:nrow(next.day))
{
  l.x<-exp(est.final$par[2*n.teams+1] + est.final$par[2*next.day$home.team[k]-1] + est.final$par[2*next.day$away.team[k]] + est.final$par[2*n.teams+2])
  l.y<-exp(est.final$par[2*n.teams+1] + est.final$par[2*next.day$away.team[k]-1] + est.final$par[2*next.day$home.team[k]])
  # vecteurs avec le nombre max de buts marqués par les deux équipes
  v1<-c(0:max(dataLigue1$FTHG))
  v2<-c(0:max(dataLigue1$FTAG))
  prob.i<-c()
  prob.j<-c()
  # calcule de la probabilité de l'équipe à domicile gagnante
  for (i in 2:(max(dataLigue1$FTHG)+1))
  {
    for (j in 1:(i-1))
    { 
      if (j>(max(dataLigue1$FTAG)+1)) break
      # produits de la probabilité que l'équipe à domicile marque le nombre de but v1[i] et que l'équipe extérieure marque j, en gardant toujours l'équipe à domicile gagnante. 
      prob.j[j]<-dpois(v1[i],l.x,log=F)*dpois(v2[j],l.y,log=F)
    }
    # somme des distributions de poisson précédentes
    prob.i[i]<-sum(prob.j, na.rm=T) 
  }
  home<-sum(prob.i[2:(max(dataLigue1$FTHG)+1)])
  prob.i<-c()
  prob.j<-c()
  # le calcul inverse: probabilité que l'équipe adverse gagne
  for (j in 2:(max(dataLigue1$FTAG)+1))  
  {
    for (i in 1:(j-1)) 
    {
      # probabilité que l'équipe extérieure gagne avec le nombre de buts v1[i]
      prob.i[i]<-dpois(v1[i],l.x,log=F)*dpois(v2[j],l.y,log=F) 
    }
    prob.j[j]<-sum(prob.i, na.rm=T) 
  }
  away<-sum(prob.j[2:(max(dataLigue1$FTAG)+1)])
  # Le match nul est la probabilité restante
  draw<-1-home-away
  pred.next<-c(pred.next,home,draw,away) 
}
predictions.next<-matrix(pred.next,ncol=3,byrow=TRUE)
# retourne un dataframe avec les rencontres et les 3 pourcentages prédits
dpred<-data.frame(home.team= next.day$HomeTeam, away.team= next.day$AwayTeam,
                       home.win=predictions.next[,1], draw=predictions.next[,2],
                       away.win=predictions.next[,3])

dpred
