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

# Plot 5 - Only motor vehicle sector, merge with Baltimore City emissions data
subSCC_MV <- SCC[str_detect(SCC$EI.Sector,"Mobile"),]
subNEICity <- subset(NEI, fips=="24510")
df_AllBCity = merge(x = subSCC_MV, y = subNEICity, by = "SCC")
# plot by year

# creating summary data, by year
df_AllBCitySum <- df_AllBCity %>%
  group_by(year) %>%
  summarize(SumEmissions = sum(Emissions))

#output plot
png(file="plot5.png", width=480, height=480)

ggplot(df_AllBCitySum, aes(x = year, y = SumEmissions)) +
  geom_line()+xlab("Year")+ylab("PM2.5 Emissions")+ggtitle("Baltimore City Motor Vehicle Emissions by Year")


dev.off()