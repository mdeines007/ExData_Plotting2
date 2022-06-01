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

# Plot 2
subNEICity <- subset(NEI, fips=="24510")
# plot by year

# creating summary data, by year
subNEICityYearSum <- subNEICity %>%
  group_by(year) %>%
  summarize(SumEmissions = sum(Emissions))

#output plot
png(file="plot2.png", width=480, height=480)

barplot(subNEICityYearSum$SumEmissions, main="Total Emissions for Baltimore City", xlab="Year", 
	names.arg=c("1999", "2002", "2005", "2008"), ylab="PM2.5 Emissions")

dev.off()