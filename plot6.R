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

# Plot 6 - Only motor vehicle sector, merge with Baltimore City and Los Angeles County emissions data
subSCC_MV <- SCC[str_detect(SCC$EI.Sector,"Mobile"),]
subNEICity <- subset(NEI, fips=="24510" | fips=="06037")
df_AllBCity = merge(x = subSCC_MV, y = subNEICity, by = "SCC")
# plot by year

# creating summary data, by year
df_AllBCitySum <- df_AllBCity %>%
  group_by(year, fips) %>%
  summarize(SumEmissions = sum(Emissions))

#output plot
png(file="plot6.png", width=480, height=480)

ggplot(df_AllBCitySum, aes(x=year)) +
  
  geom_line(data = subset(df_AllBCitySum, fips=="24510"), aes(y=SumEmissions), size=2, color="red") + 
  geom_line(data = subset(df_AllBCitySum, fips=="06037"), aes(y=SumEmissions/10), size=2, color="blue") +
  
  scale_y_continuous(
    
    # Features of the first axis
    name = "Baltimore City",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*10, name="Los Angeles County")
  ) + 
  

  theme(
    axis.title.y = element_text(color = "red", size=13),
    axis.title.y.right = element_text(color = "blue", size=13)
  ) +

  ggtitle("Motor Vehicle Emissions of Baltimore City and Los Angeles County")+
	xlab("Year")+ylab("PM2.5 Emissions")

dev.off()