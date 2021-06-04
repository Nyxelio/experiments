setwd('/home/nyxelio/Projects/R scripts')

## Understanding regression ----
## Example: Space Shuttle Launch Data ----
launch <- read.csv("challenger.csv")

# estimate beta manually
b <- cov(launch$temperature, launch$distress_ct) / var(launch$temperature)
b

# estimate alpha manually
a <- mean(launch$distress_ct) - b * mean(launch$temperature)
a

# calculate the correlation of launch data
r <- cov(launch$temperature, launch$distress_ct) /
       (sd(launch$temperature) * sd(launch$distress_ct))
r
cor(launch$temperature, launch$distress_ct)

# computing the slope using correlation
r * (sd(launch$distress_ct) / sd(launch$temperature))

# confirming the regression line using the lm function (not in text)
model <- lm(distress_ct ~ temperature, data = launch)
model
summary(model)

# creating a simple multiple regression function
reg <- function(y, x) {
  x <- as.matrix(x)
  x <- cbind(Intercept = 1, x)
  solve(t(x) %*% x) %*% t(x) %*% y
}

# examine the launch data
str(launch)

# test regression model with simple linear regression
reg(y = launch$distress_ct, x = launch[3])

# use regression model with multiple regression
reg(y = launch$distress_ct, x = launch[3:5])

# confirming the multiple regression result using the lm function (not in text)
model <- lm(distress_ct ~ temperature + pressure + launch_id, data = launch)
model