setwd('/home/nyxelio/Projects/R scripts')
insurance <- read.csv('insurance.csv', stringsAsFactors = T)

summary(insurance$charges)
cor(insurance[c("age","bmi", "children", "charges")])

pairs(insurance[c("age","bmi", "children", "charges")])

library('psych')


pairs.panels(insurance[c("age","bmi", "children", "charges")])


ins_model <- lm(charges ~ age + children + bmi + sex + smoker +region, data = insurance)

#equivalent
#ins_model <- lm(charges ~ ., data=insurance)

ins_model

summary(ins_model)

insurance$age2 <- insurance$age ^ 2 

insurance$bmi30 <- ifelse(insurance$bmi >= 30, 1, 0)

ins_model2 <- lm(charges ~ age + children + bmi + sex + bmi30*smoker + region, data = insurance)

summary(ins_model2)
