setwd("/Users/okada/myWork/coursera/ExData_Plotting1")
library(lattice);library(datasets)
xyplot(Ozone~Wind, data= airquality)
head(airquality)
airquality <- transform(airquality, Month=factor(Month))
p<-xyplot(Ozone~Wind|Month, data=airquality, layout=c(5,1))
print(p)
## lattice returns an object of class trellis

set.seed(10)
x <- rnorm(100); f <- rep(0:1, each=50)
y <- x + f - f*x + rnorm(100, sd=0.5)
f <- factor(f, labels=c("Group1", "Group2"))
xyplot(y~x|f, layout=c(2,1))
## custom panel function
xyplot(y~x|f, panel=function(x,y, ...){
  panel.xyplot(x, y, ...) # first call the default panel function for 'xyplot'
  panel.abline(h=median(y), lty=2) # add a horizontal line at the median
})
## regression line
xyplot(y~x|f, panel=function(x,y, ...){
  panel.xyplot(x, y, ...) # first call the default panel function for 'xyplot'
  panel.lmline(x,y,col=2) # add a horizontal line at the median
})


## ggplot ##
library(ggplot2)
str(mpg)
qplot(displ, hwy, data=mpg, colour=drv)
qplot(displ, hwy, data=mpg, geom=c("point","smooth"))
qplot(displ, data=mpg, fill=drv)
qplot(displ, hwy, data=mpg, facets=.~drv)
qplot(hwy, data=mpg, facets=drv~., binwidth=2)

load("maacs.Rda")
str(maacs)
qplot(log(eno), data=maacs)
qplot(log(eno), data=maacs, fill=mopos)
qplot(log(eno), data=maacs, geom="density")
qplot(log(eno), data=maacs, geom="density", colour=mopos)
qplot(log(pm25), log(eno), data=maacs)
qplot(log(pm25), log(eno), data=maacs, shape=mopos, colour=mopos)

qplot(log(pm25), log(eno), data=maacs, colour=mopos, geom=c("point","smooth"), metho="lm")
qplot(log(pm25), log(eno), data=maacs, colour=mopos, geom=c("point","smooth"), metho="loess")
qplot(log(pm25), log(eno), data=maacs, facets=.~mopos, geom=c("point","smooth"), metho="lm")
y
