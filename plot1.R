install.packages("dplyr")
install.packages("stringr") 
library(dplyr)
library(stringr)
library(ggplot2)

# Download data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
NEI <- readRDS(unzip(temp, "summarySCC_PM25.rds"))
SCC <- readRDS(unzip(temp, "Source_Classification_Code.rds"))
unlink(temp)

# Plot 1
subNEIYear <- subset(NEI, year=="1999" | year=="2002" | year=="2005" | year=="2008")
# plot by year

# creating summary data, by year
subNEIYearSum <- subNEIYear %>%
  group_by(year) %>%
  summarize(SumEmissions = sum(Emissions))

#output plot
png(file="plot1.png", width=480, height=480)

barplot(subNEIYearSum$SumEmissions, main="Total Emissions", xlab="Year", 
	names.arg=c("1999", "2002", "2005", "2008"), ylab="PM2.5 Emission", ylim=c(0,8000000))

dev.off()