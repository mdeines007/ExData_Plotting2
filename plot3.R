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

# Plot 3 - subset by one city
subNEICity <- subset(NEI, fips=="24510")

# merge with SCC data
subNEICityType = merge(x = SCC, y = subNEICity, by = "SCC")
# plot by year

# creating summary data, by year, type
subNEICityYearSum <- subNEICityType %>%
  group_by(year, type) %>%
  summarize(SumEmissions = sum(Emissions))

#output plot
png(file="plot3.png", width=480, height=480)

ggplot(subNEICityYearSum, aes(x = year, y = SumEmissions, color = type)) +
  geom_line()+xlab("Year")+ylab("PM2.5 Emissions")+ggtitle("Baltimore City Emissions by Type by Year")

dev.off()