setwd("/Users/okada/myWork/coursera/ExData_Plotting1/course_project2")
Sys.setlocale(category="LC_TIME", "en_US.UTF-8")
library(ggplot2)
library(plyr)
## read data ##
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
dim(NEI);dim(SCC)
# 6,497,651
# 11,717 records respectively
# SCC : mapping table for Source Classification Code

################################################
## Q1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.
NEI.tot <- ddply(subset(NEI, Pollutant=="PM25-PRI"), .(year), summarize, total_emissions=sum(Emissions))
plot(NEI.tot$year, NEI.tot$total_emissions, xlab="Year", 
     ylab="Total Emissions from PM2.5", main="Annual total emissions from PM2.5 in the U.S."
     , type="l")
## Yes. The total emissions decreased.

# Q2. Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to
# make a plot answering this question.
tot.balt<-ddply(subset(NEI, fips=="24510" & Pollutant=="PM25-PRI"), .(year), summarize, total_emissions=sum(Emissions))
plot(tot.balt$year, tot.balt$total_emissions, xlab="Year", 
     ylab="Total Emissions from PM2.5", 
     main="Total Emissions from PM2.5 in the Blatimore City, Maryland", type="l")

## Yes. It decreased from 1999 to 2008

# Q3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999–2008 for
# Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 
# plotting system to make a plot answer this question.
tot.balt.type<-ddply(subset(NEI, fips=="24510" & Pollutant=="PM25-PRI"), .(type, year), summarize, total_emissions=sum(Emissions))
m <- ggplot(tot.balt.type, aes(x=year, y=total_emissions, group=type, colour=type))
m + geom_line() + geom_point() + xlab("Year") + 
  ylab(expression(paste("Total emissions from PM" [2.5]))) + 
  ggtitle("Trend of total emissions from PM2.5 in the Blatimore city \n by the type of source")
## Non-point, on-road and non-road have seen decreases in emissions, while point source has seen 
## an increase.


# Q4. Across the United States, how have emissions from coal combustion-related sources changed 
# from 1999–2008?
unique(SCC$EI.Sector)
# Fuel Comb - Electric Generation - Coal, Fuel Comb - Industrial Boilers, ICEs - Coal
# Fuel Comb - Industrial Boilers, ICEs - Coal, 
# seem to be the three of the coal combustion-related sources
# 
# take SCC code 
scc.coal.comb <- subset(SCC, EI.Sector %in% c("Fuel Comb - Electric Generation - Coal",
                             "Fuel Comb - Industrial Boilers, ICEs - Coal",
                             "Fuel Comb - Industrial Boilers, ICEs - Coal"),
                        select=SCC)
# get emission data for the coal combustion
tot.us.coal <- ddply(subset(NEI, SCC %in% as.character(scc.coal.comb$SCC)& Pollutant=="PM25-PRI"), .(year), summarize, 
                     total_emissions=sum(Emissions))
m4 <- ggplot(tot.us.coal, aes(x=year, y=total_emissions))
m4 + geom_line() + geom_point() + xlab("Year") + 
  ylab(expression(paste("Total emissions from PM" [2.5]))) + 
  ggtitle("Trend of total emissions from coal combustion-related sources in the U.S.")
# The emission stayed almost flat around 550,000 ton from 1999 until 2005, 
# and it dramatically dropped by 37% to 340,692 ton.


# Q5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
unique(SCC$EI.Sector)
# Mobile - On-Road Gasoline Light Duty Vehicles
# Mobile - On-Road Gasoline Heavy Duty Vehicles     
# Mobile - On-Road Diesel Light Duty Vehicles       
# Mobile - On-Road Diesel Heavy Duty Vehicles
# seem to be four of the motor vehicle sources
# 
# take SCC code 
scc.motor <- subset(SCC, EI.Sector %in% c("Mobile - On-Road Gasoline Light Duty Vehicles",
                                              "Mobile - On-Road Gasoline Heavy Duty Vehicles",
                                              "Mobile - On-Road Diesel Light Duty Vehicles",
                                              "Mobile - On-Road Diesel Heavy Duty Vehicles"),
                        select=SCC)
tot.balt.motor <- ddply(subset(NEI, SCC %in% as.character(scc.motor$SCC) & fips=="24510" & Pollutant=="PM25-PRI"), 
                       .(year), summarize, 
                     total_emissions=sum(Emissions))
m5 <- ggplot(tot.balt.motor, aes(x=year, y=total_emissions))
m5 + geom_line() + geom_point() + xlab("Year") + 
  ylab(expression(paste("Total emissions from PM" [2.5]))) + 
  ggtitle("Trend of total emissions from motor vehicle sources \n in the Baltimore City")

# It dropped dramatically from 1999 to 2002 by 61% from 346 ton to 134 ton. It stayed almost 
# flat between 2002 and 2005, then decreased a lot again by 32% from 130 ton to 88 ton.

# Q6. Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

tot.motor.balt.cal <- ddply(subset(NEI, SCC %in% as.character(scc.motor$SCC) & 
                                     (fips=="24510" | fips=="06037") & Pollutant=="PM25-PRI"), 
                            .(fips, year), summarize, 
                            total_emissions=sum(Emissions))
# add city name
tot.motor.balt.cal$city <- ifelse(tot.motor.balt.cal$fips=="06037","Los Angels County", "Baltimore City")
# base 1999 as 100 for each city
tot.cal <- subset(tot.motor.balt.cal, fips=="06037")
tot.bal <- subset(tot.motor.balt.cal, fips=="24510")
tot.cal$emissions_100 <- tot.cal$total_emissions/subset(tot.cal, year==1999)$total_emissions*100
tot.bal$emissions_100 <- tot.bal$total_emissions/subset(tot.bal, year==1999)$total_emissions*100
tot.motor.balt.cal <- rbind(tot.cal, tot.bal)

m6 <- ggplot(tot.motor.balt.cal, aes(x=year, y=emissions_100, group=city, colour=city))
m6 + geom_line() + geom_point() + xlab("Year") + 
  ylab("Total emissions from PM2.5 (1999 = 100)") + 
  ggtitle("Trend of total emissions from PM2.5 by city\n1999 emissions = 100")
## Baltimore city has greater changes since 1999

