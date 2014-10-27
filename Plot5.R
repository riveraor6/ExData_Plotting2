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

##Subset data by Baltimor CIty and Motor Emission
motorEm <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"), ]

##Calculate aggregate
AggData <- aggregate(motorEm$Emissions, list(Year=motorEm$year), sum)

##Plot5
png(filename = "plot5.png", width = 480, height = 480, units = "px", bg = "transparent")

ggplot(AggData) + 
        geom_line(aes(y = x, x = Year)) + 
        labs(y="Amount of PM2.5 emitted") + 
        ggtitle(expression(atop("Total PM2.5 emission from motor vehicle sources", atop(italic("Baltimore City"), ""))))
dev.off()