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

# Plot 4 - Only coal sector, merge with emissions data
subSCC_Coal <- SCC[str_detect(SCC$EI.Sector,"Coal"),]
df_AllCoal = merge(x = subSCC_Coal, y = NEI, by = "SCC")
# plot by year

# creating summary data, by year
df_AllCoalSum <- df_AllCoal %>%
  group_by(year) %>%
  summarize(SumEmissions = sum(Emissions))


#output plot
png(file="plot4.png", width=480, height=480)

ggplot(df_AllCoalSum, aes(x = year, y = SumEmissions)) +
  geom_line()+xlab("Year")+ylab("PM2.5 Emissions")+ggtitle("Coal Emissions by Type by Year")


dev.off()