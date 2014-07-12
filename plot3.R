setwd("/Users/okada/myWork/coursera/ExData_Plotting1")
Sys.setlocale(category="LC_TIME", "en_US.UTF-8")
## read data ##
dat <- read.table("household_power_consumption.txt", sep=";", header=TRUE, na.strings="?")
dim(dat);head(dat)
## take rows between 2007/2/1 and 2007/2/2
dat$date1 <- as.Date(dat$Date, "%d/%m/%Y")
dat1 <- subset(dat, date1>=as.Date("2007/2/1") & date1 <= as.Date("2007/2/2"), select=-date1)
dim(dat1)
png("plot3.png")
plot(dat1$datetime, dat1$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(dat1$datetime, dat1$Sub_metering_2, col="red")
lines(dat1$datetime, dat1$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1),
       col=c("black","red","blue"))
dev.off()
