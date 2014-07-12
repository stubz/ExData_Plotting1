setwd("/Users/okada/myWork/coursera/ExData_Plotting1")
Sys.setlocale(category="LC_TIME", "en_US.UTF-8")
## read data ##
dat <- read.table("household_power_consumption.txt", sep=";", header=TRUE, na.strings="?")
dim(dat);head(dat)
## take rows between 2007/2/1 and 2007/2/2
dat$date1 <- as.Date(dat$Date, "%d/%m/%Y")
dat1 <- subset(dat, date1>=as.Date("2007/2/1") & date1 <= as.Date("2007/2/2"), select=-date1)
dim(dat1)

## plot 1 #
png("plot1.png")
hist(dat1$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)"
     , ylab="Frequency", col="red")
dev.off()
