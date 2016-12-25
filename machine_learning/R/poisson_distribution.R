dpois(x=7, lambda = 6)

sum(dpois(x=c(0:7), lambda= 6))

#prop 4 personnes et plus
1-sum(dpois(x=c(0:3), lambda = 3))