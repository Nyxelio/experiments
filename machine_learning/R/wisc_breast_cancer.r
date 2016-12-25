setwd('/home/nyxelio/Projects/R scripts')
library("class")

library('gmodels')

wbcd <- read.csv("wisc_bc_data.csv", stringsAsFactors = F)
wbcd <- wbcd[-1]
table(wbcd$diagnosis)

wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c('B', 'M'), labels = c('Begnin', 'Malignant'))
str(wbcd)
round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

normalize(c(1,2,3,4,5))

wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))
summary(wbcd_n$area_mean)

wbcd_train <- wbcd_n[1:469,]
wbcd_test <- wbcd_n[470:569,]


wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k=21)

CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)



wbcd_z <- as.data.frame(scale(wbcd[-1]))
summary(wbcd_z$area_mean)


wbcd_train <- wbcd_z[1:469,]
wbcd_test <- wbcd_z[470:569,]


wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k=21)

CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)




