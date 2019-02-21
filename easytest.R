#Easy Test
#
#
#
#install packages
install.packages(c("changepoint", "EnvCpt", "testthat"))
#load packages
packages<-c("changepoint", "EnvCpt", "testthat")
lapply(packages, require, character.only = TRUE)
#
#First get a general idea of Autoregressive models
set.seed(1)
#list description for AR(1) model
AR1sim <- list(order = c(1, 0, 0), ar = 0.2, sd = 1)
#list description for AR(2) model
AR2sim <- list(order = c(2, 0, 0), ar = c(0.5,0.2), sd = 1)
#simulate AR(1) and AR(2) like data
AR1series <- arima.sim(model = AR1sim, n = 200)
AR2series <- arima.sim(model = AR2sim, n = 200)
#plot AR(1) and AR(2) series
ARseries <- ts(data = c(AR1series,AR2series))
ts.plot(ARseries)
#
#
#Now to complete the task
#Creating test data
test <- ts(data = c(rnorm(100,0,1),rnorm(100,50,2)))
ts.plot(test)
#
#
#
#Read help on envcpt function
?envcpt
#The AR(1) and AR(2) function can be done using models = c("meanar1cpt", "meanar2cpt")
#Using the envcpt function this can be done by
testenvcpt <- envcpt(test, models = c("meanar1cpt","meanar2cpt"))
testenvcpt$meanar1cpt
testenvcpt$meanar2cpt
plot(testenvcpt)
#
#
#
#Now doing this manually with the non-exported functions
n <- length(test)
#AR1 fit
AR1.matrix <- cbind(test[-1],rep(1,n-1),test[-n])
meanar1cpt.fit <- EnvCpt:::cpt.reg(AR1.matrix)
plot(meanar1cpt.fit)
#AR2 fit
AR2.matrix <- cbind(test[-c(1:2)],rep(1,n-2),test[2:(n-1)],test[1:(n-2)])
meanar2cpt.fit <- EnvCpt:::cpt.reg(AR2.matrix)
plot(meanar2cpt.fit)
#
#Combining the graphs
par(mfrow=c(3,1))
plot(meanar2cpt.fit, ylab = "mean cpt + AR(2)")
plot(meanar1cpt.fit, ylab = "mean cpt + AR(1)")
plot(test)
#This seems appropriate however we can double check this. 
#To reset the plotting window, use par(mfrow=c(1,1))
#
#
#
#Check that the models have produced the same results using the testthat package. An example of this is
expect_equivalent(testenvcpt$meanar1cpt@cpts,meanar1cpt.fit@cpts)
#others could be done however as cpt.reg is an unexported function, not all the class objects are used.
# Checks can be done by using the @ on any object with cpt class.
