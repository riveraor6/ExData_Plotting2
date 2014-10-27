##Setting library
library(plyr)
library(ggplot2)
library(data.table)

dir <- setwd("D:/Users/Mad Labs PR/Documents/Exploratory_2")
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename1 <- "exdata-data-NEI_data.zip"
filename2 <- "Source_Classification_Code.rds"
filename3 <- "summarySCC_PM25.rds"

##Download the data is file does not exist in the working directory
if (!file.exists(filename1)) {
        download.file(url, paste("./",filename1))
        unzip(filename1, overwrite = TRUE, exdir = dir)
}

##Unzip file if rds file is not in working directory
if (!file.exists(filename2)) {
        unzip(filename1, overwrite = TRUE, exdir = dir)
}

##Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##Aggregate Emissions by year and county and filter "24510" 
AggData <- ddply(NEI[NEI$fips == "24510",], c("year", "type"), function(df)sum(df$Emissions, na.rm=TRUE))

##Plot3
png(filename="plot3.png", width=480, height=480, units = "px", bg = "transparent")

ggplot(data=AggData, aes(x=year, y=V1, group=type, colour=type)) +
        geom_line() +
        xlab("Year") +
        ylab("PM2.5 (tons)") +
        ggtitle("Total PM2.5 Emissions (tons) Per Year by Source Type")
#shutdown device
dev.off()



