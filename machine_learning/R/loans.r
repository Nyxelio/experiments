setwd('/home/nyxelio/Projects/R scripts')
library('gmodels')


credit <- read.csv("credit.csv", stringsAsFactors = F)

str(credit)

table(credit$checking_balance)

set.seed(12345)

credit_rand <- credit[order(runif(1000)), ]

head(credit$amount)

head(credit_rand$amount)


credit_train <- credit_rand[1:900,]
credit_test <- credit_rand[901:1000,]

prop.table(table(credit_train$default))

prop.table(table(credit_test$default))

library('C50')

credit_train$default <- as.factor(credit_train$default)
credit_model <- C5.0(credit_train[-17], credit_train$default)

credit_model
summary(credit_model)

credit_pred <- predict(credit_model, credit_test)

CrossTable(credit_test$default, credit_pred, prop.chisq = FALSE, prop.c = F, prop.r = F, dnn = c('actual default', 'predicted default'))

credit_boost10 <- C5.0(credit_train[-17], credit_train$default, trials= 10)

credit_boost10
summary(credit_boost10)


credit_boost_pred10 <- predict(credit_boost10, credit_test)

CrossTable(credit_test$default, credit_boost_pred10, prop.chisq = FALSE, prop.c = F, prop.r = F, dnn = c('actual default', 'predicted default'))

error_cost <- matrix(c(0,1,4,0), nrow = 2)
#error_cost

credit_cost <- C5.0(credit_train[-17], credit_train$default, costs = error_cost)

credit_cost_pred <- predict(credit_cost, credit_test)

CrossTable(credit_test$default, credit_cost_pred, prop.chisq = FALSE, prop.c = F, prop.r = F, dnn = c('actual default', 'predicted default'))

