setwd("/Users/okada/myWork/coursera/ExData_Plotting1")
Sys.setlocale(category="LC_TIME", "en_US.UTF-8")
## read data ##
dat <- read.table("household_power_consumption.txt", sep=";", header=TRUE, na.strings="?")
dim(dat);head(dat)
## take rows between 2007/2/1 and 2007/2/2
dat$date1 <- as.Date(dat$Date, "%d/%m/%Y")
dat1 <- subset(dat, date1>=as.Date("2007/2/1") & date1 <= as.Date("2007/2/2"), select=-date1)
dim(dat1)

png("plot2.png")
dat1$datetime <- as.POSIXct(strptime(paste(dat1$Date, dat1$Time), "%d/%m/%Y %H:%M:%S"), "GMT")
plot(dat1$datetime, dat1$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()
